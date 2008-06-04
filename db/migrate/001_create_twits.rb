class CreateTwits < ActiveRecord::Migration
  def self.up
    create_table (:twits,:options => 'DEFAULT CHARSET=UTF8') do |t|
    t.column :url, :string
    t.column :title, :string
    t.column :user_id, :integer
    t.column :type_id, :integer
    t.column :create_at, :datetime
    end
  end
  def self.down
    drop_table :twits
  end
end
