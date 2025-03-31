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

end