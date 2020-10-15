class Task < ApplicationRecord
  belongs_to :category

  validates :recursive, presence: true
  validates :skip_products, presence: true
  validates :url_type, presence: true # add /category|products/ checking ?
end
