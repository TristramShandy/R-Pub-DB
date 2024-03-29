module PublicationsHelper
  # visibility class of the attribute in the given scope value
  def scope_attr(scope, attr)
    visibility = case attr
                 when :volume
                   scope == 1
                 when :number
                   scope == 1
                 when :year
                   scope == 1 || scope == 2
                 when :page_begin
                   scope == 1 || scope == 2
                 when :page_end
                   scope == 1 || scope == 2
                 when :doi
                   scope != 3
                 when :citation
                   scope == 3
                 else
                   true
                 end

    visibility ? "visible" : "hidden"
  end
end
