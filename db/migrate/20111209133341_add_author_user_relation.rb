class AddAuthorUserRelation < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.integer :author_id, :null => true
    end

    execute "alter table users add constraint fk_users_authors foreign key(author_id) references authors(id)"
  end

  def self.down
    execute "alter table users drop foreign key fk_users_authors"

    change_table :users do |t|
      t.remove_column :author_id 
    end
  end
end
