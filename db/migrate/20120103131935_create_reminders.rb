class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.string :email, :null => false
      t.integer :offset, :null => false, :default => 0
      t.integer :call_id, :null => true
      t.integer :conference_id, :null => true
      t.string :attribute_name, :null => true
      t.date :send_day

      t.timestamps
    end

    execute "alter table reminders add constraint fk_reminders_calls foreign key(call_id) references calls(id)"
    execute "alter table reminders add constraint fk_reminders_conferences foreign key(conference_id) references conferences(id)"
  end

  def self.down
    execute "alter table reminders drop foreign key fk_reminders_conferences"
    execute "alter table reminders drop foreign key fk_reminders_calls"

    drop_table :reminders
  end
end
