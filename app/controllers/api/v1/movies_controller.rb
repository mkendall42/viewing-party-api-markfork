class Api::V1::MoviesController < ApplicationController
  def index
    #Check if query param passed in (determines top rated vs. searching for specific movies)
    if params[:search]
      movie_list_data = MovieGateway.get_search_movies_data(params[:search])
      filtered_movies = Movie.create_movie_list(movie_list_data, 20)

      render json: MovieSerializer.format_movie_list(filtered_movies)
    else
      #If top rated:
      movie_list_data = MovieGateway.get_top_movies_data
      top_movies = Movie.create_movie_list(movie_list_data, 20)

      render json: MovieSerializer.format_movie_list(top_movies)
    end
  end

  def show
    #External API calls to TMDB (multiple req'd due to cast and reviews peripheral data)
    movie_details_data = MovieGateway.get_movie_details(params[:id])
    movie = Movie.new(movie_details_data, true)
    movie.add_cast_and_reviews(MovieGateway.get_movie_cast_details(movie.id), MovieGateway.get_movie_reviews_details(movie.id))
    
    render json: MovieSerializer.format_movie_details(movie)
  end
end
