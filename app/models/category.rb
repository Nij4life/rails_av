require_relative '../../utils/glue'

class Category < Glue::ApplicationRecord
  has_one :task
  has_and_belongs_to_many :products, dependent: :destroy

  validates :name, presence: true
  validates :url, format: { with: /https:\/\/cars.av.by/ }
end

# Есть зацикленность. Если в базе нету категории, на сайте она не отрисуеться. Если она не отрисуеться - ее не обновить