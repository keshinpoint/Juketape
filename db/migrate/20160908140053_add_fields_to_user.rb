class AddFieldsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :finalized_setup, :boolean, default: false
    add_column :users, :image, :string
    add_column :users, :act_name, :string
    add_column :users, :tag_line, :string
  end
end
