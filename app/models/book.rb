class Book < ActiveRecord::Base
  has_many :calls
  has_many :publications
  has_and_belongs_to_many :authors

  validates_presence_of :title
  validates_presence_of :editor
  validates_presence_of :publisher
  validates_presence_of :year
  validates_presence_of :isbn

  # isbn checksum validation
  validates_each :isbn do |model, attr, value|
    cisbn = Isxn::CIsxn.new(value)
    model.errors[attr] << model.errors.generate_message(attr, :invalid) unless cisbn.valid?
  end


  include Sortable

  DisplayInfo = [
    Sortable::HeaderInfo.new(:title,            :title,           Sortable::C_Default, Sortable::C_Default),
    Sortable::HeaderInfo.new(:editor,           :editor,          Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:editor_location,  :editor_location, Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:publisher_location, :publisher_location, Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:year,             :year,            Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:isbn,             :isbn,            Sortable::C_No,      Sortable::C_No,    )]

  def display_name
    title
  end

  def select_name
    title
  end
end
