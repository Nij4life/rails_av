class Category < ApplicationRecord
  has_and_belongs_to_many :products, dependent: :destroy
  # validates :name, presence: true
  # validates :url, presence: true
end
