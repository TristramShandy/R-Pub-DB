class Publication < ActiveRecord::Base
  belongs_to :conference
  belongs_to :journal
  belongs_to :book
  belongs_to :call
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :users

  include Sortable

  DisplayInfo = [
    Sortable::HeaderInfo.new(:title,            :title,           Sortable::C_Default, Sortable::C_Default),
    Sortable::HeaderInfo.new(:source,           :source,          Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:abstract,         :abstract,        Sortable::C_No,      Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:status,           :status,          Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:pdf_link,         :pdf,             Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:doi,              :doi,             Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:volume,           :volume,          Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:number,           :number,          Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:pages,            :pages,           Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:year,             :year,            Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:authors,          :authors,         Sortable::C_No,      Sortable::C_No     )]

  StatusFinished = 10

  def finished?
    status < StatusFinished
  end
end
