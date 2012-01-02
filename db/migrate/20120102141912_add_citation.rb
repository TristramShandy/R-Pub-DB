class AddCitation < ActiveRecord::Migration
  def self.up
    change_table :publications do |t|
      t.text :citation, :null => true
    end
  end

  def self.down
    change_table :publications do |t|
      t.remove_column :citation
    end
  end
end
