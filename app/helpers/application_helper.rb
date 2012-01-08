module ApplicationHelper
  # returns link for a sortable header of list items
  def sortable_header(header_item)
    title = t(header_item.name)
    css_class = (header_item.attribute == @list.sort ? "current #{@list.direction}" : nil)
    direction = (header_item.attribute == @list.sort && @list.direction == :asc ? :desc : :asc)
    if header_item.is_sortable?
      param_hash = {:sort => header_item.attribute.to_s, :direction => direction.to_s}
      @filter_info.each do |info|
        i = info.index
        param_hash["regexp_#{i}".to_sym] = info.regexp
        param_hash["ignorecase_#{i}".to_sym] = (info.ignorecase ? '1' : nil)
        param_hash["attr_select_#{i}".to_sym] = info.attribute
      end
      link_to title, param_hash, {:class => css_class}
    else
      title
    end
  end 

  # default scope to use for an object
  def default_scope(obj)
    return 0 if obj[:conference_id]
    return 1 if obj[:journal_id]
    return 2 if obj[:book_id]
    return (Publication === obj ? 3 : 0)
  end

  # visibility class of the given scope values
  def scope_visible(s0, s1)
    s0 == s1 ? "visible" : "hidden"
  end

  # options string for scope selection
  def scope_select_options
    [[t(:conference), 0], [t(:journal), 1], [t(:book), 2], [t(:other), 3]]
  end

  # label and help for the given attribute
  def label_and_help(f, attr)
    help_sym = "help_#{attr}".to_sym
    raw "#{f.label attr} <span class='helptext'>#{I18n.t help_sym}</span><br />"
  end
end
