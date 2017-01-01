class AddWelcomeMessageToInvitatations < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :welcome_message, :text, default: ''
  end
end
