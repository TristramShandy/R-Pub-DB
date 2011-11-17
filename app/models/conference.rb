class Conference < ActiveRecord::Base
  has_many :calls
  has_many :publications

  include Sortable

  DisplayInfo = [
    Sortable::HeaderInfo.new(:name,             :name,            Sortable::C_Default, Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:begin_date,       :begin_date,      Sortable::C_Yes,     Sortable::C_Default),
    Sortable::HeaderInfo.new(:end_date,         :end_date,        Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:deadline,         :deadline,        Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:acceptance,       :acceptance,      Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:due,              :due,             Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:submission_type,  :submission_type, Sortable::C_No,      Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:webpage,          :url,             Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:location,         :location,        Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:title_proceed,    :proceedings,     Sortable::C_Yes,     Sortable::C_Yes    )]


end
