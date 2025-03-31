class MovieGateway
  #Handles connections and returning appropriate dataset(s)

  #NOTE: IDEA FOR POLYMORPHISM: connedtion = Faraday.new stuff, then inherit smaller classes to call specific 'gets'
  #This seems awfully 'manufactured' just to sneak this in though...

  def self.get_top_movies_data
    connection = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      #NOTE: the actual key needed the prefix "Bearer <token>".  Arrrgh!
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:bearer_token]
    end

    response = connection.get("/3/movie/top_rated")
    # movie_list_data = JSON.parse(response.body, symbolize_names: true)

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_search_movies_data(search_param)
    connection = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      #NOTE: the actual key needed the prefix "Bearer <token>".  Arrrgh!
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:bearer_token]
    end

    response = connection.get("/3/search/movie?query=#{search_param}")
    # movie_list_data = JSON.parse(response.body, symbolize_names: true)

    JSON.parse(response.body, symbolize_names: true)
  end

  #   filtered_movies = movie_list_data[:results].reduce([]) do |movies, movie_data|
  #     movies << Movie.new(movie_data)
  #   end

  #   #Return only max_entries (20 usually - should be page limit, but add it nonetheless)
  #   filtered_movies = filtered_movies[0..(max_entries - 1)] if filtered_movies.length > 20

  #   filtered_movies
  # end

  def self.get_movie_details(movie_id)
    connection = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:bearer_token]
    end

    response = connection.get("/3/movie/#{movie_id}")

    JSON.parse(response.body, symbolize_names: true)

    #Do I want to massage this / explicitly call a Movie object, or be consistent and just return raw data?
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
    #
    connection = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:bearer_token]
    end

    response = connection.get("/3/movie/#{movie_id}/reviews")

    JSON.parse(response.body, symbolize_names: true)

    # movie_reviews[:results]
  end
end