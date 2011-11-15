class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.references :conference
      t.references :journal
      t.references :book
      t.date :deadline
      t.string :url
      t.string :guest_editor

      t.timestamps
    end
  end

  def self.down
    drop_table :calls
  end
end
