class Publication < ActiveRecord::Base
  belongs_to :conference
  belongs_to :journal
  belongs_to :book
  belongs_to :call
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :users

  StatusFinished = 10

  def finished?
    status < StatusFinished
  end
end
