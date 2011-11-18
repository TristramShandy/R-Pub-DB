module ApplicationHelper
  # returns link for a sortable header of list items
  def sortable_header(header_item)
    title = t(header_item.name)
    css_class = (header_item.attribute == session[:sort_column] ? "current #{session[:sort_direction]}" : nil)
    direction = (header_item.attribute == session[:sort_column] && session[:sort_direction] == :asc ? :desc : :asc)
    link_to title, {:sort => header_item.attribute.to_s, :direction => direction.to_s}, {:class => css_class}
  end 

  # returns path to edit method of a sortable item
  def edit_path(element)
    # ... #
  end 
end
