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
    str_value = value.strip
    if str_value =~ /^[0-9]{4}-[0-9]{3}[0-9xX]$/
      coeff = [8, 7, 6, 5, 0, 4, 3, 2]
      checksum = (0..7).inject(0) {|s, i| s + coeff[i] * str_value[i].to_i}
      check_bit = (str_value[8].upcase == 'X' ? 10 : str_value[8].to_i)
      if (check_bit + checksum) % 11 != 0
        model.errors[:issn] << model.errors.generate_message(:issn, :invalid)
      end
    else
      model.errors[:issn] << model.errors.generate_message(:issn, :invalid)
    end
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
