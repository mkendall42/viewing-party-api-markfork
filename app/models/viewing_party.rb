class ViewingParty < ApplicationRecord
  #Needs associations here
  has_many :viewing_party_registrations
  has_many :users, through: :viewing_party_registrations

  # def initialize(viewing_party_params)
  #   #Do I want to call this first, or super() first?  (or is super() even needed?)
  #   create_registrations(viewing_party_params[:invitees])

  #   #POTENTIAL PROBLEM: the record doesn't exist in DB yet (save() not yet called)
  #   #Can't access things like its id yet for create_registration
  #   #I think I can do this via callbacks, but need more research into this!
    
  # end

  # def create_registrations(invitee_ids)
  #   invitee_ids.each do |invitee_id|
  #     #Later: could do exception handling here (this is why I added this line - make sure we can actually find it!!!)
  #     found_user = User.find(invitee_id)
  #     ViewingPartyRegistration.create!(found_user.id, self.id)
  #   end
  # end

  def set_host(user_id)
    #Update DB record with user's registration as host for this party

    # binding.pry

    #First, reset all hosts to false, then update [new] specified host to true
    viewing_party_registrations.each do |registration|
      registration.set_host_status(false)
    end

    binding.pry

    viewing_party_registrations.find_by(user_id: user_id).set_host_status(true)
    # viewing_party_registrations.find_by(user_id: user_id).is_host = true
    # viewing_party_registrations.find_by(user_id: user_id).save

  end

  def find_host
    #Assumes only one host (no co-hosting) for now
    viewing_party_registrations.find_by(is_host: true).user
  end
end
