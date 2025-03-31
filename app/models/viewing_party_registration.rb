class ViewingPartyRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :viewing_party

  validates :user_id, presence: true
  validates :viewing_party_id, presence: true

  before_create :default_host_state       #To correctly initialize entries (default hosting should be 'false', not just 'nil')

  def set_host_status(new_host_status)
    #self. is required for is_host (otherwise thinks it's just a random new var)...caused me more grief than it should have    
    self.is_host = new_host_status
    self.save
  end

  def default_host_state
    self.is_host = false if self.is_host == nil   #'Amusing': had an infinite loop here earlier because I used 'before_save' callback!
  end
end