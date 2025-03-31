class Api::V1::ViewingPartiesController < ApplicationController
  def create
    #Run an external TMDB request to get movie duration (requires valid movie ID, etc.)
    movie_details_data = MovieGateway.get_movie_details(viewing_party_params[:movie_id])

    #Verify start / end times make sense given movie runtime
    movie = Movie.new(movie_details_data, true)
    party_time_minutes = (params[:end_time].to_datetime - params[:start_time].to_datetime) * 24 * 60

    if movie.runtime > party_time_minutes.to_f
      render json: { message: "Error: movie runtime is longer than party duration; please make start_date and end_date sufficiently far apart.", status: 400}, status: 400
      return
    end

    new_party = ViewingParty.create!(viewing_party_params)
    #NOTE: could refactor this elsewhere (PORO maybe, since does more than just model would)
    params[:invitees].each do |invitee_id|
      found_user = User.find(invitee_id)
      ViewingPartyRegistration.create!(user_id: found_user.id, viewing_party_id: new_party.id)
    end

    new_party.set_host(params[:host])
    new_party.find_host

    render json: ViewingPartySerializer.format_party_data(new_party)
  end

  private

  def viewing_party_params
    #Not ALL of these must be present, but most (validations should cover most of rest)
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :invitees)
  end
end
