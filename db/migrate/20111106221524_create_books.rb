class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :title
      t.string :publisher
      t.string :editor
      t.integer :year
      t.string :isbn

      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
