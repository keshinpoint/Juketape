class AddInviteCodeToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :invite_code, :string, default: ''

    User.all.each do |user|
      user.send(:generate_invite_code)
      user.save
    end
  end

  def down
    remove_column :users, :invite_code
  end
end
