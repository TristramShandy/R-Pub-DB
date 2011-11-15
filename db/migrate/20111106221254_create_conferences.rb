class CreateConferences < ActiveRecord::Migration
  def self.up
    create_table :conferences do |t|
      t.string :name
      t.date :begin_date
      t.date :end_date
      t.date :deadline
      t.date :acceptance
      t.date :due
      t.string :submission_type
      t.string :url
      t.string :location
      t.string :proceedings

      t.timestamps
    end
  end

  def self.down
    drop_table :conferences
  end
end
