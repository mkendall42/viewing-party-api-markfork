class Api::V1::MoviesController < ApplicationController

  #This will handle:
  # - List top rated movies (index)
  # - Search movies (index)
  # - Movie details (show)

  def index
    #Check if query param passed in (determines top rated vs. searching for specific movies)

    #If top rated:
    #Open / run Faraday request to TMDB API (later: move to gateway)
    #Manipulate / massage movie data (later: move to Movie PORO)
    #Serialize and render appropriate JSON
    
    connection = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      #NOTE: the actual key needed the prefix "Bearer <token>".  Arrrgh!
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:bearer_token]
    end

    response = connection.get("/3/movie/top_rated")
    movie_list_data = JSON.parse(response.body, symbolize_names: true)

    #Remember to return only max of 20 entries (should be page limit, but add it nonetheless)



    binding.pry

    #Do I need to send a specific code, or just 200?
    render json: { data: "hello" }
    # render json: MovieSerializer.format_movie_list(movie_list_data)

    # response = connection.get("/videos/search", { query: artist })
    # videos_data = JSON.parse(response.body, symbolize_names: true)

    # videos_data[:videos][0]
  end

end
