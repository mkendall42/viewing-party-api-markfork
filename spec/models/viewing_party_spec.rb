require "rails_helper"

RSpec.describe ViewingParty, type: :model do
  describe "validations" do
    it { should have_many(:users).through(:viewing_party_registrations) }
  end
  
end