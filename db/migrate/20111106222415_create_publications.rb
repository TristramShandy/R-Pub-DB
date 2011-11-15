class CreatePublications < ActiveRecord::Migration
  def self.up
    create_table :publications do |t|
      t.references :conference
      t.references :journal
      t.references :book
      t.integer :status
      t.string :history
      t.string :pdf
      t.text :abstract
      t.string :doi
      t.integer :pages
      t.integer :volume
      t.integer :number
      t.string :titel
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :publications
  end
end
