require 'pry'
require 'curb'
require 'json'
require 'active_record'
require 'sqlite3'
require_relative '../app/models/task'
require_relative '../app/models/category'
require_relative '../app/models/product'
require_relative 'constants'
require_relative 'parser_helper'

class Parser
  include ParserHelper

  def initialize(params)
    @start_url = params[:url]
    @url_type = params[:url_type]
    @recursive = true?(params[:recursive])
    @skip_products = true?(params[:skip_products])
    @categories = Hash.new()
    @main_categories_info = []
  end

  # ruby parser.rb -u https://cars.av.by/jeep/patrion -t categories -s false -r true
  # patrioN !! сделать rescue

  def start
    search(@start_url)
  end

  private

  def get_info(product)
    # products.keys => # [ "id", "version", "sellerName", "questionAllowed", "publishedAt", "refreshedAt", "locationName",
    # "shortLocationName",  "photos", "status", "publicStatus", "advertType", "properties", "description", "exchange",
    #  "top",  "highlight", "videoUrl", "videoUrlId", "publicUrl", "metaInfo", "renewedAt", "metadata", "price"]
    info = {}
    info[ID] = product[ID]
    info[URL] = product[PUBLIC_URL]
    info[PHOTOS] = product[PHOTOS].dig(0, SMALL, URL)
    info[YEAR] = product[PROPERTIES].select { |el| el[ID] == 6 }[0][VALUE].to_i
    info[PRICE] = product[PRICE][USD][AMOUNT]
    info[CITY] = product[SHORT_LOCATION_NAME]
    info[NAME] = product[PROPERTIES].select { |el| [2, 3, 4].include?(el[ID]) }.map { |el| el[VALUE] }.join(' ')
    info[DESCRIPTION] = product[DESCRIPTION]
    info
  end

  def get_id_category(response_category)
    str = response_category[INITIAL_VALUE]
    str.scan(/=\d+/).map { |id| id[/\d+/] }
  end

  def add_category(category_name, response_category)
    id_list = get_id_category(response_category) # id_list because id can be: brand or brand, model

    part_request_body = if id_list.size == 1
                          [{ NAME => BRAND, VALUE => id_list[0] }]
                        else
                          [{ NAME => BRAND, VALUE => id_list[0] }, { NAME => MODEL, VALUE => id_list[1] }]
                        end

    category = { 'part_request_body': part_request_body, products: [] }
    @categories.merge!(category_name => category)
    category
  end

  def get_category_name(page)
    nodes = query_get_elements(page, "//li[@class='breadcrumb-item']").to_a
    nodes.size < 2 ? (return 'All') : nodes.shift

    extract_name = -> (*arr) { arr.map { |nok| get_value(nok, './/span').gsub('Купить ', '') }.join(JOIN_ARROW) }

    extract_name.(*nodes)
  end

  def search(url)
    puts "Зашел на url: #{url}"
    uri = get_uri(url)
    category_name = get_category_name(get_nok(url))

    response_category = request_category_page(uri.path)

    category = add_category(category_name, response_category) unless @categories.include?(category_name)

    return if response_category[ADVERTS].empty? # Because do not somethingsq

    extract_products(response_category, category) unless @skip_products
    update_db(category_name, url)

    if @recursive
      links = response_category['seo']['links'].map { |cat| cat[URL] }
      links.each { |link| search(link) }
    end
  end

  def create_product(info)
    # info >> [ID] [URL] [PHOTOS] [YEAR] [PRICE] [CITY] [NAME] [DESCRIPTION]
    Product.create(ad_id: info[ID], name: info[NAME], url: info[URL], city: info[CITY], year: info[YEAR],
                   price: info[PRICE], photo_url: info[PHOTOS], description: info[DESCRIPTION])
  rescue => e
    # был случай продукта-теста на сайте. он не прошел validate базы и exception
    puts e.message
    puts e.backtrace
    binding.pry
  end

  def update_or_create_category(category_name, url)
    cat = Category.find_by_name(category_name) || Category.new(name: category_name, url: url)
    cat.updated_at = Time.now # without this line cat.save don't update date
    cat.save
  end

  def get_categories(category_name)
    name = category_name.split(JOIN_ARROW).shift.strip
    Category.where('name LIKE ?', "%#{name}%")
  end

  def update_db(category_name, url)
    update_or_create_category(category_name, url)
    categories = get_categories(category_name)

    @categories[category_name][:products].each do |info|
      unless Product.exists?(ad_id: info[ID])

        product = create_product(info)
        product.categories = categories
      end

    rescue => e
      # был случай продукта-теста на сайте. он не прошел validate базы и exception
      puts e.message
      puts e.backtrace
      binding.pry
    end
  end

  def request_category_page(path)
    api_link = path.empty? ? 'https://api.av.by/offer-types/cars/filters/main/init' : "https://api.av.by/offer-types/cars/landings#{path}"

    JSON Curl.get(api_link) { |curl| curl.headers = DEFAULT_HEADERS }.body_str
    # response.keys => # ["blocks", "count", "pageCount", "page", "adverts", "sorting", "currentSorting", "advertsPerPage", "initialValue", "extended", "seo"]
  end

  def create_post_body(page_number, part_request_body)
    { PAGE => page_number,
      PROPERTIES => [
        { NAME => BRANDS, 'property' => 5, VALUE => [part_request_body] },
        { NAME => 'price_currency', VALUE => 2 }
      ],
      'sorting' => 1}
  end

  def request_products(page_number, part_request_body)
    post_body = create_post_body(page_number, part_request_body)

    res = JSON Curl.post('https://api.av.by/offer-types/cars/filters/main/apply',
                         post_body.to_json) { |curl| curl.headers = DEFAULT_HEADERS }.body_str
  end

  def extract_products(response_category, category)
    products = [*response_category[ADVERTS]]

    if response_category[PAGE_COUNT] > 1
      start_range = response_category[PAGE] + 1
      end_range = response_category[PAGE_COUNT]

      (start_range..end_range).step do |i|
        res = request_products(i, category[:part_request_body])
        products += res[ADVERTS] if res.presence
      rescue
        # тут была странная ошибка. на audi 121 и выше стр. приходил result['adverts'] == []
        # когда достигли лимита продуктов 3000
      end
    end

    category[:products] = products.map { |product| get_info(product) }
    # puts "#{response_category['seo']['currentPage']['url']} : #{category[:products].size} products"
  end
end
