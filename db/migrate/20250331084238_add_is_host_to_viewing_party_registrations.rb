class AddIsHostToViewingPartyRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :viewing_party_registrations, :is_host, :boolean
  end
end
