require "rails_helper"

RSpec.describe ViewingPartyRegistration, type: :model do
  describe "validations" do
    it { should belong_to(:user) }
    it { should belong_to(:viewing_party) }
  end

  before(:each) do
    @user1 = User.create!(name: "James Raynor", username: "Jimmy", password: "mengsksucks")
    @user2 = User.create!(name: "Sarah Kerrigan", username: "QueenOfBlades", password: "agreewithjimmy")
    @user3 = User.create!(name: "Fenix", username: "TheDragoon", password: "dontlikebetrayal")
    @user4 = User.create!(name: "Raszagal", username: "Matriarch", password: "meneither")

    @great_party = ViewingParty.create!(name: "Post-BroodWar Speedrun", start_time: "2025-04-02 19:00:00", end_time: "2025-04-02 22:30:00", movie_id: 278, movie_title: "The Shawshank Redemption")
    @vpr1 = ViewingPartyRegistration.create!(user_id: @user1.id, viewing_party_id: @great_party.id, is_host: false)
    @vpr2 = ViewingPartyRegistration.create!(user_id: @user3.id, viewing_party_id: @great_party.id, is_host: false)
    @vpr3 = ViewingPartyRegistration.create!(user_id: @user4.id, viewing_party_id: @great_party.id, is_host: false)
  end

  describe ".set_host_status method" do
    it "correctly set host status for a given user (2 sequential examples)" do
      @vpr2.set_host_status(false)
      expect(ViewingPartyRegistration.all.find_by(is_host: true)).to eq(nil)

      @vpr2.set_host_status(true)
      expect(ViewingPartyRegistration.all.find_by(is_host: true)).to eq(@vpr2)
    end

    it "correctly default host statuses to false" do
      @vpr1.is_host = nil
      @vpr1.default_host_state

      expect(@vpr1.is_host).to eq(false)
    end
  end
  
end