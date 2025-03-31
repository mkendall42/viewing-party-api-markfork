require "rails_helper"

RSpec.describe "Users API", type: :request do
  describe "Create User Endpoint" do
    let(:user_params) do
      {
        name: "Me",
        username: "its_me",
        password: "QWERTY123",
        password_confirmation: "QWERTY123"
      }
    end
    
    
    context "request is valid" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_users_path, params: user_params, as: :json
        
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(User.last.id.to_s)
        expect(json[:data][:attributes][:name]).to eq(user_params[:name])
        expect(json[:data][:attributes][:username]).to eq(user_params[:username])
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes]).to_not have_key(:password)
        expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
      end
    end
    
    context "request is invalid" do
      it "returns an error for non-unique username" do
        User.create!(name: "me", username: "its_me", password: "abc123")
        
        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username has already been taken")
        expect(json[:status]).to eq(400)
      end
      
      it "returns an error when password does not match password confirmation" do
        user_params = {
          name: "me",
          username: "its_me",
          password: "QWERTY123",
          password_confirmation: "QWERT123"
        }
        
        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end
      
      it "returns an error for missing field" do
        user_params[:username] = ""
        
        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end
  
  describe "Get All Users Endpoint" do
    it "retrieves all users but does not share any sensitive data" do
      User.create!(name: "Tom", username: "myspace_creator", password: "test123")
      User.create!(name: "Oprah", username: "oprah", password: "abcqwerty")
      User.create!(name: "Beyonce", username: "sasha_fierce", password: "blueivy")
      
      get api_v1_users_path
      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      
      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:attributes]).to have_key(:name)
      expect(json[:data][0][:attributes]).to have_key(:username)
      expect(json[:data][0][:attributes]).to_not have_key(:password)
      expect(json[:data][0][:attributes]).to_not have_key(:password_digest)
      expect(json[:data][0][:attributes]).to_not have_key(:api_key)
    end
  end
  
  describe "Show user information endpoint" do
    before(:each) do
      @user1 = User.create!(name: "James Raynor", username: "Jimmy", password: "mengsksucks")
      @user2 = User.create!(name: "Sarah Kerrigan", username: "QueenOfBlades", password: "agreewithjimmy")
      @user3 = User.create!(name: "Fenix", username: "TheDragoon", password: "dontlikebetrayal")
      @user4 = User.create!(name: "Raszagal", username: "Matriarch", password: "meneither")
  
      @great_party = ViewingParty.create!(name: "Post-BroodWar Speedrun", start_time: "2025-04-02 19:00:00", end_time: "2025-04-02 22:30:00", movie_id: 278, movie_title: "The Shawshank Redemption")
      @another_great_party = ViewingParty.create!(name: "Half-Life Episode 3 Gathering", start_time: "2025-04-02 19:00:00", end_time: "2025-04-02 22:30:00", movie_id: 278, movie_title: "The Shawshank Redemption")
      ViewingPartyRegistration.create!(user_id: @user1.id, viewing_party_id: @great_party.id, is_host: true)
      ViewingPartyRegistration.create!(user_id: @user3.id, viewing_party_id: @great_party.id, is_host: false)
      ViewingPartyRegistration.create!(user_id: @user4.id, viewing_party_id: @great_party.id, is_host: false)
      ViewingPartyRegistration.create!(user_id: @user3.id, viewing_party_id: @another_great_party.id, is_host: true)
      ViewingPartyRegistration.create!(user_id: @user4.id, viewing_party_id: @another_great_party.id, is_host: false)
    end

    context "happy path (user exists)" do
      it "correctly renders detailed user information (2 examples)", :vcr do
        #First user (who is not a host)
        get api_v1_user_path(@user4.id)
        user_data = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to be_successful
        expect(user_data[:data][:id]).to eq(@user4.id)
        expect(user_data[:data][:type]).to eq("user")
        expect(user_data[:data]).to have_key(:attributes)
        user_attrs = user_data[:data][:attributes]
        expect(user_attrs[:name]).to be_a(String)
        expect(user_attrs[:username]).to be_a(String)
        expect(user_attrs[:username]).to be_a(String)
        expect(user_attrs[:viewing_parties_hosted]).to be_a(Array)
        expect(user_attrs[:viewing_parties_hosted].length).to eq(0)
        expect(user_attrs[:viewing_parties_invited]).to be_a(Array)
        expect(user_attrs[:viewing_parties_invited].length).to eq(2)

        #Second user (who is a host)
        get api_v1_user_path(@user3.id)
        user_data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        user_attrs = user_data[:data][:attributes]
        expect(user_attrs[:viewing_parties_hosted]).to be_a(Array)
        expect(user_attrs[:viewing_parties_hosted].length).to eq(1)
        expect(user_attrs[:viewing_parties_invited]).to be_a(Array)
        expect(user_attrs[:viewing_parties_invited][1][:host_id]).to eq(@user3.id)
      end
    end

    context "sad paths (invalid user id, etc.)" do
      xit "cannot locate invalid user id", :vcr do
        invalid_id = 100000
        get api_v1_user_path(invalid_id)

        error_message = JSON.parse(response.body, symbolize_names: true)

        #NOTE: add error message checking (once full exception handling works)
      end
    end
  end
end
