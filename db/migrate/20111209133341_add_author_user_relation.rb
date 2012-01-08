class AddAuthorUserRelation < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.integer :author_id, :null => true
    end

    execute "alter table users add constraint fk_users_authors foreign key(author_id) references authors(id)"
  end

  def self.down
    execute "alter table users drop foreign key fk_users_authors"

    remove_column :users, :author_id 
  end
end
