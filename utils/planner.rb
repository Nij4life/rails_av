require 'active_record'
require 'sqlite3'
require_relative '../app/models/task'
require_relative '../app/models/category'
require_relative 'parser'

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => "/home/alex/ruby/rails/av/db/development.sqlite3")

class Planner
  def search(param)
    av = Parser.new(param)
    av.start
  end

  def find_category(category_id)
    Category.find(category_id)
  end

  def do_task(params)
    av = Parser.new(params)
    av.start
  end

  def check_task
    task = Task.take

    return false unless task

    category = find_category(task[:category_id])
    do_task(url: category[:url], url_type: 'category', recursive: task[:recursive], skip_products: task[:skip_products])
    task.delete
  end

end

planner = Planner.new

loop do
  puts '...check the task every 30 seconds...'
  planner.check_task
  sleep(30)
end

# ActiveRecord::Base.connection.execute('select * from products')
#
# ruby parser.rb -u https://cars.av.by -t categories -r true -s true
#
# connection adapter
# ActiveRecord::Base.connection
# execute(sql, name = nil) public
# Выполняет инструкцию SQL в контексте этого соединения и возвращает необработанный результат от адаптера соединения.
