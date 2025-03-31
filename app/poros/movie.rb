class Movie
  attr_reader :id, :title, :vote_average, :summary, :release_year, :runtime, :genres, :cast, :total_reviews, :reviews

  def initialize(movie_data, is_detailed_info = false)
    @id = movie_data[:id]
    @title = movie_data[:title]
    @vote_average = movie_data[:vote_average]

    #Instance vars only for movie details (just nil otherwise)
    if is_detailed_info
      @summary = movie_data[:overview]
      @release_year = movie_data[:release_date]     #Maybe: just pull out year
      @runtime = movie_data[:runtime]
      @genres = extract_genres(movie_data[:genres])

      #Later: could call add_cast_and_reviews from here
    end
  end

  def add_cast_and_reviews(cast_data, review_data)
    @cast = extract_cast(cast_data)
    @total_reviews = review_data[:total_results]
    @reviews = extract_reviews(review_data)
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
      cast << { character: cast_member[:character], actor: cast_member[:name] }
    end

    cast_members = cast_members[0..9] if cast_members.length > 10

    cast_members
  end

  def extract_reviews(review_data)
    reviews = review_data[:results].reduce([]) do |all_reviews, review|
      all_reviews << { author: review[:author], review: review[:content] }
    end

    reviews = reviews[0..4] if reviews.length > 5

    reviews
  end

end