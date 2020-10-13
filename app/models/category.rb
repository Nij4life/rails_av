class Category < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true
  has_and_belongs_to_many :products
end
