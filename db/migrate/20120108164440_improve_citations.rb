class ImproveCitations < ActiveRecord::Migration
  # New requirements in citations
  def self.up
    change_table :books do |t|
      t.string :editor_location, :null => true
      t.string :publisher_location, :null => true
    end

    remove_column :publications, :pages

    change_table :publications do |t|
      t.integer :page_begin, :null => true
      t.integer :page_end, :null => true
    end
  end

  def self.down
    remove_column :books, :publisher_location
    remove_column :books, :editor_location

    change_table :publications do |t|
      t.integer :pages, :null => true
    end

    remove_column :publications, :page_end
    remove_column :publications, :page_begin
  end
end
