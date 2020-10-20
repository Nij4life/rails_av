require_relative '../../utils/glue'

class Task < Glue::ApplicationRecord
  belongs_to :category

  validates :recursive, inclusion: { in: [true, false] }
  validates :skip_products, inclusion: { in: [true, false] }
  validates :url_type, format: { with: /category|products/ }
  # add validates for state, if that need
end
