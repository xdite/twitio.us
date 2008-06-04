class CreateUserTypes < ActiveRecord::Migration
  def self.up
    create_table (:user_types,:options => 'DEFAULT CHARSET=UTF8') do |t|
    t.column :type_name ,:string
    t.column :user_id, :integer
    t.column :created_at, :datetime
  end
  end
  def self.down
    drop_table :user_types
  end
end
