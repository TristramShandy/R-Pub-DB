module PublicationsHelper

  # default scope to use for the publication
  def default_scope(publ)
    return 0 if publ[:conference_id]
    return 1 if publ[:journal_id]
    return 2 if publ[:book_id]
    return 3
  end

  # visibility class of the given scope values
  def scope_visible(s0, s1)
    s0 == s1 ? "visible" : "hidden"
  end

  # visibility class of the attribute in the given scope value
  def scope_attr(scope, attr)
    visibility = case attr
                 when :volume
                   scope == 1
                 when :number
                   scope == 1
                 when :year
                   scope == 1 || scope == 2
                 when :pages
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
