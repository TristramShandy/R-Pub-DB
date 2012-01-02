class Journal < ActiveRecord::Base
  has_many :calls
  has_many :publications

  include Sortable

  DisplayInfo = [
    Sortable::HeaderInfo.new(:name,             :name,            Sortable::C_Default, Sortable::C_Default),
    Sortable::HeaderInfo.new(:publisher,        :publisher,       Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:issn,             :issn,            Sortable::C_No,      Sortable::C_No,    ),
    Sortable::HeaderInfo.new(:webpage,          :url,             Sortable::C_No,      Sortable::C_No     )]

  def display_name
    name
  end

  def select_name
    name
  end
end
