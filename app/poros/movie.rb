class Movie
  attr_reader :id, :title, :vote_average

  def initialize(movie_data)
    @id = movie_data[:id]
    @title = movie_data[:title]
    @vote_average = movie_data[:vote_average]
  end

  def self.create_movie_list(movie_list_data, max_entries)
    filtered_movies = movie_list_data[:results].reduce([]) do |movies, movie_data|
      movies << Movie.new(movie_data)
    end

    #Return only max_entries (20 usually - should be page limit, but add it nonetheless)
    filtered_movies = filtered_movies[0..(max_entries - 1)] if filtered_movies.length > 20

    filtered_movies
  end

end