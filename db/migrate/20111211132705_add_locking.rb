class AddLocking < ActiveRecord::Migration
  def self.up
    add_column :authors, :lock_version, :integer, :default => 0
    add_column :books, :lock_version, :integer, :default => 0
    add_column :calls, :lock_version, :integer, :default => 0
    add_column :conferences, :lock_version, :integer, :default => 0
    add_column :journals, :lock_version, :integer, :default => 0
    add_column :publications, :lock_version, :integer, :default => 0
    add_column :users, :lock_version, :integer, :default => 0
  end

  def self.down
    remove_column :users, :lock_version
    remove_column :publications, :lock_version
    remove_column :journals, :lock_version
    remove_column :conferences, :lock_version
    remove_column :calls, :lock_version
    remove_column :books, :lock_version
    remove_column :authors, :lock_version
  end
end
