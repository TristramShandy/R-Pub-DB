class Author < ActiveRecord::Base
  has_and_belongs_to_many :publications
  has_and_belongs_to_many :books
  has_one :user

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :affiliation

  include Sortable

  DisplayInfo = [
    Sortable::HeaderInfo.new(:first_name,       :first_name,      Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:last_name,        :last_name,       Sortable::C_Default, Sortable::C_Default),
    Sortable::HeaderInfo.new(:affiliation,      :affiliation,     Sortable::C_Yes,     Sortable::C_Yes    )]

  def display_name
    "#{last_name} #{first_name}"
  end

  # name to be displayed on selection
  def select_name
    "#{last_name} #{first_name}, #{affiliation}"
  end
end
