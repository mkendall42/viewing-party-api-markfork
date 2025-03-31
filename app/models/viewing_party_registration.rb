class ViewingPartyRegistration < ApplicationRecord
  #Set up associations here
  belongs_to :user
  belongs_to :viewing_party
end