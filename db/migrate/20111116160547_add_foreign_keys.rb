class AddForeignKeys < ActiveRecord::Migration
  def self.up
    change_table :publications do |t|
      t.integer :call_id, :null => true
    end

    # association table authors - publications
    create_table :authors_publications, :id => false do |t|
      t.integer :author_id, :null => false
      t.integer :publication_id, :null => false
    end

    # association table publications - users
    create_table :publications_users, :id => false do |t|
      t.integer :publication_id, :null => false
      t.integer :user_id, :null => false
    end

    # add foreign key constraints
    execute "alter table calls add constraint fk_calls_conferences foreign key(conference_id) references conferences(id)"
    execute "alter table calls add constraint fk_calls_journals foreign key(journal_id) references journals(id)"
    execute "alter table calls add constraint fk_calls_books foreign key(book_id) references books(id)"
    execute "alter table publications add constraint fk_publications_conferences foreign key(conference_id) references conferences(id)"
    execute "alter table publications add constraint fk_publications_journals foreign key(journal_id) references journals(id)"
    execute "alter table publications add constraint fk_publications_books foreign key(book_id) references books(id)"
    execute "alter table publications add constraint fk_publications_calls foreign key(call_id) references calls(id)"
    execute "alter table authors_publications add constraint fk_authors_publications_authors foreign key(author_id) references authors(id)"
    execute "alter table authors_publications add constraint fk_authors_publications_publications foreign key(publication_id) references publications(id)"
    execute "alter table publications_users add constraint fk_publications_users_publications foreign key(publication_id) references publications(id)"
    execute "alter table publications_users add constraint fk_publications_users_users foreign key(user_id) references users(id)"
  end

  def self.down
    execute "alter table publications_users drop foreign key fk_publications_users_users"
    execute "alter table publications_users drop foreign key fk_publications_users_publications"
    execute "alter table authors_publications drop foreign key fk_authors_publications_publications"
    execute "alter table authors_publications drop foreign key fk_authors_publications_authors"
    execute "alter table publications drop foreign key fk_publications_calls"
    execute "alter table publications drop foreign key fk_publications_books"
    execute "alter table publications drop foreign key fk_publications_journals"
    execute "alter table publications drop foreign key fk_publications_conferences"
    execute "alter table calls drop foreign key fk_calls_books"
    execute "alter table calls drop foreign key fk_calls_journals"
    execute "alter table calls drop foreign key fk_calls_conferences"

    drop_table :publications_users
    drop_table :authors_publications

    change_table :publications do |t|
      t.remove_column :call_id 
    end
  end
end
