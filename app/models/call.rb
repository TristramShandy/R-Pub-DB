class Call < ActiveRecord::Base
  belongs_to :conference
  belongs_to :journal
  belongs_to :book
  has_many :publications
end
