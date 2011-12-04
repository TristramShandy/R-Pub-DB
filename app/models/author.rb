class Author < ActiveRecord::Base
  has_and_belongs_to_many :publications

  include Sortable

  DisplayInfo = [
    Sortable::HeaderInfo.new(:first_name,       :first_name,      Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:last_name,        :last_name,       Sortable::C_Default, Sortable::C_Default),
    Sortable::HeaderInfo.new(:affiliation,      :affiliation,     Sortable::C_Yes,     Sortable::C_Yes    )]

  def display_name
    "#{first_name} #{last_name}"
  end
end
