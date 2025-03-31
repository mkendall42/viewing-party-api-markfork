class Api::V1::ViewingPartiesController < ApplicationController

  #This will handle:
  # - Create new viewing party (create)
  # - Probaby: add new user to party (update) (could do via Users controller, but seems a little 'out of scope' there...)
  def create
    #First, check that things make sense:
    # - Start time is before end time (implied / handled by the next point)
    # - Party duration is less than runtime

    #Run an external TMDB request to get movie duration (requires valid movie ID, etc.)
    #Is that sad path necessary to handle?
    movie_details_data = MovieGateway.get_movie_details(viewing_party_params[:movie_id])

    # binding.pry

    # movie_details_data = MovieGateway.get_movie_details(params[:id])
    movie = Movie.new(movie_details_data, true)
    party_time_minutes = (params[:end_time].to_datetime - params[:start_time].to_datetime) * 24 * 60
    # binding.pry

    if movie.runtime > party_time_minutes.to_f
      #Note: this inequality structuring automatically captures an end time before start time error as well
      
      # render json: ErrorSerializer.format_error(elapsed_time_error)
      render json: { message: "Error: movie runtime is longer than party duration; please make start_date and end_date sufficiently far apart.", status: 400}, status: 400
      return
    end

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
