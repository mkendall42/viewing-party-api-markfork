# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

#NOTE: destroy_all() is STILL not resetting IDs correctly.  Why not?! (Jacob had/has this issue too)
User.destroy_all    #Ensures IDs are reset correctly
user1 = User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
user2 = User.create!(name: "Dolly Parton", username: "dollyP", password: "Jolene123")
user3 = User.create!(name: "Lionel Messi", username: "futbol_geek", password: "test123")

ViewingParty.destroy_all  #Same here
vp1 = ViewingParty.create!(name: "Welcome to Shawshank Party", start_time: "2025-04-02 19:00:00", end_time: "2025-04-02 22:30:00", movie_id: 278, movie_title: "The Shawshank Redemption")
# ViewingParty.create!(name: "Terminator II with Ahhhnold", start_time: "2025-04-02 19:00:00", end_time: "2025-04-02 22:30:00", movie_id: 278, movie_title: "The Shawshank Redemption")

ViewingPartyRegistration.destroy_all    #Might not need it here, but let's be safe...
ViewingPartyRegistration.create!(user_id: user1.id, viewing_party_id: vp1.id, is_host: true)
ViewingPartyRegistration.create!(user_id: user2.id, viewing_party_id: vp1.id, is_host: false)
ViewingPartyRegistration.create!(user_id: user3.id, viewing_party_id: vp1.id, is_host: false)

