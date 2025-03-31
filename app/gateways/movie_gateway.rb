class MovieGateway
  #NOTE: polymorphism might be usable here to make more DRY, but would be an awfully 'manufactured' inheritance structure in this case
  #Or use the appeanding capability I just learned about (not enough time to implement)

  def self.get_top_movies_data
    connection = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      #NOTE: the actual key needed the prefix "Bearer <token>".  Arrrgh!
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:bearer_token]
    end

    response = connection.get("/3/movie/top_rated")

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_search_movies_data(search_param)
    connection = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:bearer_token]
    end

    response = connection.get("/3/search/movie?query=#{search_param}")

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_movie_details(movie_id)
    connection = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:bearer_token]
    end

    response = connection.get("/3/movie/#{movie_id}")

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_movie_cast_details(movie_id)
    connection = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:bearer_token]
    end

    response = connection.get("/3/movie/#{movie_id}/credits")
    movie_credits = JSON.parse(response.body, symbolize_names: true)

    movie_credits[:cast]      #Only return the cast (not all data)
  end

  def self.get_movie_reviews_details(movie_id)
    connection = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:bearer_token]
    end

    response = connection.get("/3/movie/#{movie_id}/reviews")

    JSON.parse(response.body, symbolize_names: true)
  end
end