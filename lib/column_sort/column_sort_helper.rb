module ColumnSort
  module ColumnSortHelper

    # Sets the default column sort for the view
    # Updates the params directly
    # 
    # @param [String or Symbol] column The name of the sort column
    # @param [String or Symbol] column The direction of the sort
    def set_default_column_sort(column, direction)
      if params.present?
        if params[:column_sort].nil?
          params[:column_sort] = { 
            :column => column,
            :direction => direction
          }   
        end 
      end 
    end 

    # Generates a link that sorts the page based on the current params
    #
    # @param [Symbol] column_symbol The name of the sort column
    # @param [String] column_name Display name for the sort column, defaults to the titlezed sort column
    #
    # @return [String] Link back to the current page with the new sorting parameters
    def column_sort_link(column_symbol, column_name = nil)
      # default column name to column symbol titleized
      column_name = column_symbol.to_s.titleize if column_name.nil?

      # set default link attributes
      # note that we default to ascending search
      link_attributes = {:column_sort => { :column => column_symbol, :direction => "asc" }}

      # start building the link text
      link_text = column_name
      if params[:column_sort].present?
        if params[:column_sort][:column].to_s == column_symbol.to_s
          # if sorting on the current column, add an arrow for the current direction and make the link sort in the opposite direction
          if params[:column_sort][:direction].to_s == "desc"
            link_text += '&#9660;' # ▼
            link_attributes[:column_sort][:direction] = "asc"
          else
            link_text += '&#9650;' # ▲
            link_attributes[:column_sort][:direction] = "desc"
          end 
        else
          # if not sorting on the current column, add a diamond and use the default sort direction
          link_text += ' &#9830;' # ♦
        end 
      else
        # if no sort is specified, add a diamond and use the default sort direction
        link_text += ' &#9830;' # ♦
      end 
      # return html string for an a tag with the correct request parameters
      link_to link_text.html_safe, link_attributes 
    end 
  end
end
