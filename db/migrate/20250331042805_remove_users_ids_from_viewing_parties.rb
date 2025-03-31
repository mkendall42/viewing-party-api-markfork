class RemoveUsersIdsFromViewingParties < ActiveRecord::Migration[7.1]
  def change
    remove_column :viewing_parties, :users_id, :string
  end
end
