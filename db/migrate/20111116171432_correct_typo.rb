class CorrectTypo < ActiveRecord::Migration
  def self.up
    change_table :publications do |t|
      t.rename :titel, :title
    end
  end

  def self.down
    change_table :publications do |t|
      t.rename :title, :titel
    end
  end
end
