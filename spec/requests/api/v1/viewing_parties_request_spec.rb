require "rails_helper"

RSpec.describe "Viewing Parties - create, add users", type: :request do
  before(:each) do
    @user1 = User.create!(name: "James Raynor", username: "Jimmy", password: "mengsksucks")
    @user2 = User.create!(name: "Sarah Kerrigan", username: "QueenOfBlades", password: "agreewithjimmy")
    @user3 = User.create!(name: "Fenix", username: "TheDragoon", password: "dontlikebetrayal")
    @user4 = User.create!(name: "Raszagal", username: "Matriarch", password: "meneither")
  end

  describe "create new viewing party" do
    context "happy path (creation request valid)" do
      it "can create viewing party, return proper status" do
        party_info = {
          "name": "Post-BroodWar Bash",
          "start_time": "2025-02-01 10:00:00",
          "end_time": "2025-02-01 14:30:00",
          "movie_id": 278,
          "movie_title": "The Shawshank Redemption",
          "invitees": [@user1.id, @user3.id, @user4.id]   #Just passing integers risky - IDs will likely change in DB over time...
        }

        post api_v1_viewing_parties_path, params: party_info, as: :json
        # post api_v1_artist_songs_path(@prince), params: song_params, as: :json
        created_party_data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        #Test for the moment:
        binding.pry

        # expect(created_party_data).to eq({ data: "created" })

        #General structure of JSON response
        expect(created_party_data).to have_key(:data)
        expect(created_party_data[:data]).to be_a(Hash)
        expect(created_party_data[:data][:id]).to be_a(Integer)
        expect(created_party_data[:data][:type]).to eq("viewing_party")
        expect(created_party_data[:data][:attributes]).to be_a(Hash)
        expect(created_party_data[:data][:attributes][:name]).to eq("Post-BroodWar Bash")
        expect(created_party_data[:data][:attributes][:start_time].include?("10:00:00")).to eq(true)    #Due to slightly different date/time formatting on these lines, just look for substring
        expect(created_party_data[:data][:attributes][:end_time].include?("14:30:00")).to eq(true)
        expect(created_party_data[:data][:attributes][:movie_id]).to eq(278)
        expect(created_party_data[:data][:attributes][:movie_title]).to eq("The Shawshank Redemption")
        expect(created_party_data[:data][:attributes][:invitees]).to be_a(Array)
        
        # #Invitee specific information
        invitees = created_party_data[:data][:attributes][:invitees]
        expect(invitees[0][:id]).to eq(@user1.id)
        expect(invitees[0][:name]).to eq(@user1.name)
        expect(invitees[0][:username]).to eq(@user1.username)
        expect(invitees[1][:id]).to eq(@user3.id)
        expect(invitees[1][:name]).to eq(@user3.name)
        expect(invitees[1][:username]).to eq(@user3.username)
        expect(invitees[2][:id]).to eq(@user4.id)
        expect(invitees[2][:name]).to eq(@user4.name)
        expect(invitees[2][:username]).to eq(@user4.username)

        #NOTE: there HAS to be a way to do this more efficiently than the above!!!
        #Maybe make a memoized method or something at least?
        # invitees_array = [@user1, @user3, @user4]
        # created_party_data[:data][:attributes][:invitees].each do |invitee|
        #   expect(invitee[:id]).to include()
        #   expect(invitees_array)
        # end
        # expect(created_party_data[:data][:attributes][:movie_id]).to eq("The Shawshank Redemption")
      end

      it "ignores any extraneous parameters" do

      end
    end

    context "sad path (invalid creation requests, edge cases)" do

    end
  end

end