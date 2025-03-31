class Api::V1::MoviesController < ApplicationController

  #This will handle:
  # - [DONE] List top rated movies (index)
  # - [PENDING - STUBBING ERROR] Search movies (index)
  # - Movie details (show)

  def index
    #Check if query param passed in (determines top rated vs. searching for specific movies)

    if params[:search]
      #If query param (search movies by name)
      # connection = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      #   #NOTE: the actual key needed the prefix "Bearer <token>".  Arrrgh!
      #   faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:bearer_token]
      # end
      # response = connection.get("/3/search/movie?query=#{params[:search]}")
      # movie_list_data = JSON.parse(response.body, symbolize_names: true)

      # binding.pry

      # filtered_movies = movie_list_data[:results].reduce([]) do |movies, movie_data|
      #   movies << Movie.new(movie_data)
      # end

      # #Remember to return only max of 20 entries (should be page limit, but add it nonetheless)
      # filtered_movies = filtered_movies[0..19] if filtered_movies.length > 20

      movie_list_data = MovieGateway.get_search_movies_data(params[:search])
      filtered_movies = Movie.create_movie_list(movie_list_data, 20)
      #Do I need to send a specific code, or just 200?
      render json: MovieSerializer.format_movie_list(filtered_movies)

    else
      #If top rated:
      movie_list_data = MovieGateway.get_top_movies_data
      top_movies = Movie.create_movie_list(movie_list_data, 20)

      #Do I need to send a specific code, or just 200?
      render json: MovieSerializer.format_movie_list(top_movies)
    end
  end

  def show
    #External API calls to TMDB (multiple req'd due to cast and reviews peripheral data)
    movie_details_data = MovieGateway.get_movie_details(params[:id])
    movie = Movie.new(movie_details_data, true)
    movie.add_cast_and_reviews(MovieGateway.get_movie_cast_details(movie.id), MovieGateway.get_movie_reviews_details(movie.id))
    
    binding.pry
    # render json: { data: "empty for now" }
    render json: MovieSerializer.format_movie_details(movie)
  end

end
