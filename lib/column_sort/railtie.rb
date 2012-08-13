require 'rails'

# no config for now
# require 'column_sort/config'

module ColumnSort 
  class Railtie < ::Rails::Railtie
    initializer 'column_sort' do |app|
      require "column_sort/column_sort_in_model"
      ActiveRecord::Base.send :include, ColumnSort::ColumnSortInModel

      # note that the helpers are required in both views and controllers
      # There is a way in rails to make helpers available in controllers but I am
      # not sure how to use it here.  A potentially better way to do this is to convert
      # the gem to an engine and put it in app/helpers/column_sort/
      require "column_sort/column_sort_helper"
      ActionView::Base.send :include, ColumnSort::ColumnSortHelper
      ActionController::Base.send :include, ColumnSort::ColumnSortHelper
    end
  end
end
