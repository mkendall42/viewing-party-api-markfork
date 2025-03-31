class ViewingPartyRegistration < ApplicationRecord
  #Set up associations here
  belongs_to :user
  belongs_to :viewing_party

  def set_host_status(new_host_status)
    #self. is required for is_host (otherwise thinks it's just a random new var)...caused me more grief than it should have    
    self.is_host = new_host_status
    self.save
  end
end