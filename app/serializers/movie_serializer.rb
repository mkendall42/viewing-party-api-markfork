class MovieSerializer
  def self.format_movie_list(movies)
    #For listing multiple movies (simpler dataset returned)
    # movies_array = []
    # movies.each do |movie|
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

end