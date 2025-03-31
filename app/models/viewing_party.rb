class ViewingParty < ApplicationRecord
  #Needs associations here
  has_many :viewing_party_registrations
  has_many :users, through: :viewing_party_registrations
end