class CreateDtypes < ActiveRecord::Migration
  def self.up
    create_table (:dtypes,:options => 'DEFAULT CHARSET=UTF8') do |t|
        t.column :dtype_name ,:string
        t.column :user_id, :integer
        t.column :twit_id, :integer
        t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :dtypes
  end
end
