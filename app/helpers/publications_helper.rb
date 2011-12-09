module PublicationsHelper
  # check if the given attribute is writeable and return a hash string to that effect
  def check_writable(attr_name)
    @publication.editable?(attr_name, @user) ? {} : {:disabled => "disabled"}
  end

  # default scope to use for the publication
  def default_scope(publ)
    return 0 if publ[:conference_id]
    return 1 if publ[:journal_id]
    return 2 if publ[:book_id]
    
    return 0
  end

  # visibility class of the given scope values
  def scope_visible(s0, s1)
    s0 == s1 ? "visible" : "hidden"
  end
end
