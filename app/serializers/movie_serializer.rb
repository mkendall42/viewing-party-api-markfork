class MovieSerializer
  def self.format_movie_list(movies)
    movies_array = movies.reduce([]) do |acc, movie|
      movie_hash = {
        id: movie.id,
        type: "movie",
        attributes: {
          title: movie.title,
          vote_average: movie.vote_average
        }
      }

      acc << movie_hash
    end

    { data: movies_array }
  end

  def self.format_movie_details(movie)
    {
      data: {
        id: movie.id,
        type: "movie",
        attributes: {
          title: movie.title,
          release_year: movie.release_year,
          vote_average: movie.vote_average,
          runtime: movie.runtime,
          genres: movie.genres,
          summary: movie.summary,
          cast: movie.cast,
          total_reviews: movie.total_reviews,
          reviews: movie.reviews
        }
      }
    }
  end
end