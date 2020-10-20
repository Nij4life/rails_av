require_relative '../../utils/glue'

class Product < Glue::ApplicationRecord
  has_and_belongs_to_many :categories, touch: :categories_updated_at # check, delete .save in parser!

  validates :ad_id, numericality: { only_integer: true }
  validates :name, presence: true
  validates :url, format: { with: /https:\/\/cars.av.by/ }
  validates :price, numericality: {only_integer: true, greater_than: 0}
  #validates :price, { numericality: {only_integer: true} }
end

# Не нравиться переделанные [PHOTOS]. Теперь там 1на photo_url!
