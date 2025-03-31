class Api::V1::ViewingPartiesController < ApplicationController

  #This will handle:
  # - Create new viewing party (create)
  # - Probaby: add new user to party (update) (could do via Users controller, but seems a little 'out of scope' there...)
  def create
    #Create the viewing party
    new_party = ViewingParty.create!(viewing_party_params)
    #Register / associate the users with the party (can't forget this...like I did!)
    #Should be able to do this directly within the model, methinks!

    # binding.pry
    
    params[:invitees].each do |invitee_id|
      found_user = User.find(invitee_id)
      ViewingPartyRegistration.create!(user_id: found_user.id, viewing_party_id: new_party.id)
    end
    
    # binding.pry

    # render json: { data: "created" }
    render json: ViewingPartySerializer.format_party_data(new_party)
  end

  private

  def viewing_party_params
  #Not ALL of these must be present, but ~9osome should (set up validations later)
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :invitees)
  end

end
