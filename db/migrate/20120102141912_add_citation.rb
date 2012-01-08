class AddCitation < ActiveRecord::Migration
  def self.up
    change_table :publications do |t|
      t.text :citation, :null => true
    end
  end

  def self.down
    remove_column :publications, :citation
  end
end
