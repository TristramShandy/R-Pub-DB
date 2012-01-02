class Book < ActiveRecord::Base
  has_many :calls
  has_many :publications
  has_and_belongs_to_many :authors

  validates_presence_of :title
  validates_presence_of :editor
  validates_presence_of :publisher
  validates_presence_of :year
  validates_presence_of :isbn

  include Sortable

  DisplayInfo = [
    Sortable::HeaderInfo.new(:title,            :title,           Sortable::C_Default, Sortable::C_Default),
    Sortable::HeaderInfo.new(:editor,           :editor,          Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:publisher,        :publisher,       Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:year,             :year,            Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:isbn,             :isbn,            Sortable::C_No,      Sortable::C_No,    )]

  def display_name
    title
  end

  def select_name
    title
  end
end
