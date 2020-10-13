class Product < ApplicationRecord
  validates :ad_id, presence: true
  validates :name, presence: true
  validates :url, presence: true
  validates :price, presence: true
  has_and_belongs_to_many :categories
end
