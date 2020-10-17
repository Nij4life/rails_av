require 'active_record'

module Glue
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end

# добавить сюда мб подгрузку модулей нужных для active records   class Load....