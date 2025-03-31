require "rails_helper"

RSpec.describe "Viewing Party Registrations", type: :request do
  before(:each) do
    @user1 = User.create!(name: "James Raynor", username: "Jimmy", password: "mengsksucks")
    @user2 = User.create!(name: "Sarah Kerrigan", username: "QueenOfBlades", password: "agreewithjimmy")
    @user3 = User.create!(name: "Fenix", username: "TheDragoon", password: "dontlikebetrayal")
    @user4 = User.create!(name: "Raszagal", username: "Matriarch", password: "meneither")
  end

  it "can add an existing user to an existing viewing party", :vcr do
    great_party = ViewingParty.create!(name: "Post-BroodWar Speedrun", start_time: "2025-04-02 19:00:00", end_time: "2025-04-02 22:30:00", movie_id: 278, movie_title: "The Shawshank Redemption")
    ViewingPartyRegistration.create!(user_id: @user1.id, viewing_party_id: great_party.id, is_host: true)
    ViewingPartyRegistration.create!(user_id: @user3.id, viewing_party_id: great_party.id, is_host: false)
    ViewingPartyRegistration.create!(user_id: @user4.id, viewing_party_id: great_party.id, is_host: false)
    user_to_add_params = {
      viewing_party_id: great_party.id,
      # invitees_user_id: @user2.id
      user_id: @user2.id
    }
    
    post api_v1_viewing_party_registrations_path, params: user_to_add_params, as: :json
    # patch api_v1_viewing_party_path(great_party.id), params: user_to_add_params, as: :json
    party_response = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    expect(party_response[:data][:attributes][:invitees].length).to eq(4)
    expect(party_response[:data][:attributes][:invitees]).to include({ id: @user2.id, name: @user2.name, username: @user2.username })
  end
  

end