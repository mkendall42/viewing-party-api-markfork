require "rails_helper"

RSpec.describe ViewingParty, type: :model do
  describe "validations" do
    it { should have_many(:users).through(:viewing_party_registrations) }
  end

  before(:each) do
    @user1 = User.create!(name: "James Raynor", username: "Jimmy", password: "mengsksucks")
    @user2 = User.create!(name: "Sarah Kerrigan", username: "QueenOfBlades", password: "agreewithjimmy")
    @user3 = User.create!(name: "Fenix", username: "TheDragoon", password: "dontlikebetrayal")
    @user4 = User.create!(name: "Raszagal", username: "Matriarch", password: "meneither")

    @great_party = ViewingParty.create!(name: "Post-BroodWar Speedrun", start_time: "2025-04-02 19:00:00", end_time: "2025-04-02 22:30:00", movie_id: 278, movie_title: "The Shawshank Redemption")
    ViewingPartyRegistration.create!(user_id: @user1.id, viewing_party_id: @great_party.id, is_host: false)
    ViewingPartyRegistration.create!(user_id: @user3.id, viewing_party_id: @great_party.id, is_host: false)
    ViewingPartyRegistration.create!(user_id: @user4.id, viewing_party_id: @great_party.id, is_host: false)
  end

  describe ".set_host and .find_host methods" do
    it "correctly sets host for given party" do
      #These are pretty intimately intertwined
      @great_party.set_host(@user3.id)

      expect(@great_party.find_host).to eq(@user3)
    end
  end
end