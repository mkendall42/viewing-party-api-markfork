require "rails_helper"

RSpec.describe "Movie class" do
  it "Creates a movie object based on properly formatted input hash" do
    input_hash = {
      id: 12345,
      title: "2001: A Space Odyssey",
      vote_average: 9.9
    }

    great_movie = Movie.new(input_hash)

    expect(great_movie).to be_a(Movie)
    expect(great_movie.id).to eq(12345)
    expect(great_movie.title).to eq("2001: A Space Odyssey")
    expect(great_movie.vote_average).to eq(9.9)
  end

  it "Creates a movie object with detailed information" do
    #This also implicitly tests extract_ methods (private)
    detailed_movie_hash = {
      id: 12345,
      title: "2001: A Space Odyssey",
      vote_average: 9.9,
      release_date: "1968",
      runtime: 139,
      genres: [
        { id: 42, name: "Science Fiction" },
        { id: 54, name: "Drama" }
      ],
      overview: "One of the greatest movies of all time. The physics on the space station is exquisite. No room for debate."
    }

    cast_info = [
      #Note: this is an array per what MovieGateway returns!
      {
        name: "Keir Dullea",
        original_name: "the same",
        cast_id: 3,
        character: "Dr David Bowen"
      },
      {
        name: "Gary Lockwood",
        original_name: "the same again",
        cast_id: 7,
        character: "Dr Frank Poole"
      },
      {
        name: "HAL 9000, the scariest AI ever",
        original_name: "IBM",
        cast_id: 1,
        character: "HAL"
      }
    ]

    reviews_info = {
      results: [
        { author: "Johnny B Goode", author_details: {}, content: "It was great", url: "a.place.org/hi" },
        { author: "Lucy in the Sky with Diamonds", author_details: {}, content: "REALLY great", url: "a.place.org/hi" }
      ],
      total_results: 2
    }

    #At last, create the movie object
    great_movie = Movie.new(detailed_movie_hash, true)
    great_movie.add_cast_and_reviews(cast_info, reviews_info)
  
    expect(great_movie.genres).to eq(["Science Fiction", "Drama"])
    expect(great_movie.release_year).to eq("1968")
    expect(great_movie.runtime).to eq(139)
    expect(great_movie.summary).to be_a(String)
    #Cast info
    expect(great_movie.cast.length).to eq(3)
    expect(great_movie.cast[2][:character]).to eq("HAL")
    expect(great_movie.cast[2][:actor]).to eq("HAL 9000, the scariest AI ever")
    #Reviews info
    expect(great_movie.total_reviews).to eq(2)
    expect(great_movie.reviews.length).to eq(2)
    expect(great_movie.reviews[0][:author]).to eq("Johnny B Goode")
    expect(great_movie.reviews[0][:review]).to eq("It was great")
  end

end