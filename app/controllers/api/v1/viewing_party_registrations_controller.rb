class Api::V1::ViewingPartyRegistrationsController < ApplicationController
  def create

    # binding.pry

    party = ViewingParty.find(params[:viewing_party_id])
    party.viewing_party_registrations.create!(viewing_party_registration_params)

    # binding.pry

    render json: ViewingPartySerializer.format_party_data(party)
  end

  private

  def viewing_party_registration_params
    params.permit(:viewing_party_id, :user_id, :is_host)
    #Can I re-write params here to be different names?  Or are they pretty static (other than in routes.rb)?
    # params[:user_id] = params[:invitee_id]
  end
end