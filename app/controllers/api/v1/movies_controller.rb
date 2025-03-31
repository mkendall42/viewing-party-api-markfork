class Api::V1::MoviesController < ApplicationController

  #This will handle:
  # - [DONE] List top rated movies (index)
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

    # binding.pry

    top_movies = movie_list_data[:results].reduce([]) do |movies, movie_data|
      movies << Movie.new(movie_data)
    end

    #Remember to return only max of 20 entries (should be page limit, but add it nonetheless)
    top_movies = top_movies[0..19] if top_movies.length > 20


    #Do I need to send a specific code, or just 200?
    render json: MovieSerializer.format_movie_list(top_movies)
  end

end
