class AddPageIdToFacebookNetworks < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_networks, :page_id, :string, default: ''
    add_column :facebook_networks, :all_pages, :json, array: true, default: []
  end
end
