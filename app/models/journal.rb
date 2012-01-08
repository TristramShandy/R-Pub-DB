require 'isxn'

class Journal < ActiveRecord::Base
  has_many :calls
  has_many :publications

  include Sortable
  include ActiveModel::Validations

  validates_presence_of :name
  validates_presence_of :publisher
  validates_presence_of :issn
  validates_presence_of :url

  # issn checksum validation
  validates_each :issn do |model, attr, value|
    cissn = Isxn::CIsxn.new(value)
    model.errors[attr] << model.errors.generate_message(attr, :invalid) unless cissn.valid?
  end


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
