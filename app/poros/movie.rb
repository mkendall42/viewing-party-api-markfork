class Movie
  attr_reader :id, :title, :vote_average

  def initialize(movie_data)
    @id = movie_data[:id]
    @title = movie_data[:title]
    @vote_average = movie_data[:vote_average]

    #Instance vars only for movie details (just nil otherwise)
    @summary = movie_data[:overview]
    @release_year = movie_data[:release_date]     #Maybe: just pull out year
    @runtime = movie_data[:runtime]
    @genres = extract_genres(movie_data[:genres])
    @cast = extract_cast(MovieGateway.get_movie_cast_details(movie_data[:id]))        #This should be constrained to <= 10.  SHIT; this is not listed here, probably requires another call...
    #Placeholder for now - need extractor method later
    @total_reviews = 0
    @reviews = 0     #This should be constrained to <= 5
  end

  def self.create_movie_list(movie_list_data, max_entries)
    filtered_movies = movie_list_data[:results].reduce([]) do |movies, movie_data|
      movies << Movie.new(movie_data)
    end

    #Return only max_entries (20 usually - should be page limit, but add it nonetheless)
    filtered_movies = filtered_movies[0..(max_entries - 1)] if filtered_movies.length > 20

    filtered_movies
  end

  private

  def extract_genres(genres_data)
    genres_data.reduce([]) do |genres, genre_hash|
      genres << genre_hash[:name]
    end
  end

  def extract_cast(cast_data)
    cast_members = cast_data.reduce([]) do |cast, cast_member|
      cast << { character: cast_member[:character], name: cast_member[:name] }
    end

    cast_members = cast_members[0..9] if cast_members.length > 10

    cast_members
  end

end