module ColumnSort
  module ColumnSortInModel

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # Set the different types of sorts the front end can call
      #
      # This method is used to ensure that whatever sort is called from the column_sort scope will not
      # trigger a missing method exception.  This will throw exceptions for the missing scopes when the
      # application.  Additionally, sorts that are not included in this list will not be executed when 
      # column_sort is called.  Taking strings from a params hash and directly converting them to method
      # names without any security is a little scary.
      #
      # This method is optional.  If it is not called, column_sort will blindly attempt to call any scope
      # given to it.
      #
      # @param [Array] An array of column names
      def sortable_columns(columns)
        columns = [columns] unless columns.is_a? Array
        mattr_accessor :sortable_column_list
        self.sortable_column_list = columns

        columns.each do |column|
          if !self.respond_to?("column_sort_#{column}_asc")
            throw "Missing ascending sort scope for #{column}"
          end
          if !self.respond_to?("column_sort_#{column}_desc")
            throw "Missing descending sort scope for #{column}"
          end
        end 
      end 

      # Calls a sorting scope based on the given parameters
      #
      # If the column and direction parameters are set, attempt to find a matching scope and call it.
      # Otherwise, returns a chainable object that does not affect the outcome of the query.
      #
      # See the sortable_columns method for more information on how this works.
      #
      #
      # @params [Hash] params A hash with two optional keys, column and direction
      def column_sort(params)
        # if parameters are present, attempt to run a scope, otherwise add an empty where
        if params.present? && params[:column].present? && params[:direction].present?
          # if sortable_column_list is empty, just run the scope
          # otherwise, check if the parameters match the values in sortable_column_list
          if sortable_column_list.nil?
            scope_name = "column_sort_#{params[:column]}_#{params[:direction]}".downcase
            send(scope_name)
          else
            # if sortable_column_list is not empty, check to make sure the column is a member of the list 
            # before continuing
            if !sortable_column_list.include?(params[:column].to_sym) || params[:direction].nil?
              where({}) 
            else
              scope_name = "column_sort_#{params[:column]}_#{params[:direction]}".downcase
              send(scope_name)
            end 
          end 
        else
          where({})
        end 
      end 
    end
  end
end
