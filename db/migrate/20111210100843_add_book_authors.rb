class AddBookAuthors < ActiveRecord::Migration
  def self.up
    # association table authors - books
    create_table :authors_books, :id => false do |t|
      t.integer :author_id, :null => false
      t.integer :book_id, :null => false
    end

    # add foreign key constraints
    execute "alter table authors_books add constraint fk_authors_books_authors foreign key(author_id) references authors(id)"
    execute "alter table authors_books add constraint fk_authors_books_books foreign key(book_id) references books(id)"
  end

  def self.down
    execute "alter table authors_books drop foreign key fk_authors_books_books"
    execute "alter table authors_books drop foreign key fk_authors_books_authors"

    drop_table :authors_books
  end
end
