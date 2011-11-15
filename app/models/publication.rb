class Publication < ActiveRecord::Base
  belongs_to :conference
  belongs_to :journal
  belongs_to :book
end
