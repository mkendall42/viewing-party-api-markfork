class Api::V1::ViewingPartiesController < ApplicationController

  #This will handle:
  # - Create new viewing party (create)
  # - Probaby: add new user to party (update) (could do via Users controller, but seems a little 'out of scope' there...)
  def create
    ViewingParty.create!(viewing_party_params)

    render json: { data: "created" }
  end

  private

  def viewing_party_params
    #Not ALL of these must be present, but some should (set up validations later)
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :invitees)
  end
  
end
