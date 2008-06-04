class CreateTypes < ActiveRecord::Migration
  def self.up
    create_table :types do |t|
    t.column :type_name, :integer
    end
  end

  def self.down
    drop_table :types
  end
end
