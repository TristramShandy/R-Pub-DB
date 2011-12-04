module ApplicationHelper
  # returns link for a sortable header of list items
  def sortable_header(header_item)
    title = t(header_item.name)
    css_class = (header_item.attribute == @list.sort ? "current #{@list.direction}" : nil)
    direction = (header_item.attribute == @list.sort && @list.direction == :asc ? :desc : :asc)
    if header_item.is_sortable?
      link_to title, {:sort => header_item.attribute.to_s, :direction => direction.to_s}, {:class => css_class}
    else
      title
    end
  end 

  # options string for scope selection
  def scope_select_options
    [[t(:conference), 0], [t(:journal), 1], [t(:book), 2]]
  end
end
