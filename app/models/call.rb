class Call < ActiveRecord::Base
  belongs_to :conference
  belongs_to :journal
  belongs_to :book
  has_many :publications

  include Sortable

  DisplayInfo = [
    Sortable::HeaderInfo.new(:source,           :source,          Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:deadline,         :deadline,        Sortable::C_Default, Sortable::C_Default),
    Sortable::HeaderInfo.new(:webpage,          :url,             Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:guest_editor,     :guest_editor,    Sortable::C_No,      Sortable::C_No     )]
end