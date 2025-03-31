require "rails_helper"

RSpec.describe "Movies API", type: :request do
  describe "List top-rated movies" do
    context "happy path (request valid)" do
      it "contains correct fields" do
        #Need to setup mocking / stubbing ASAP now that I know it's working

        #A complication: how to stub 'nested' request
        get api_v1_movies_path
        movies_json = JSON.parse(response.body, symbolize_names: true)

        binding.pry

        expect(response).to be_successful

        expect(movies_json).to have_key(:data)
        expect(movies_json[:data]).to be_a(Array)

        movies_json[:data].each do |movie_data|
          expect(movie_data).to have_key(:id)
          expect(movie_data).to have_key(:type)
          expect(movie_data[:type]).to eq("movie")
          expect(movie_data).to have_key(:attributes)
          expect(movie_data[:attributes]).to have_key(:title)
          expect(movie_data[:attributes]).to have_key(:vote_average)
        end
      end

      xit "lists a maximum of 20 movies" do
        #No fancy way to test this short of querying multiple pages on TMDB methinks...
        #Check class is Array as well
        movies_data = []
        21.times do |i|
          misc_movie_data = {
            id: i,
            title: "Some movie #{i}",
            vote_average: i % 10
          }

          movies_data << misc_movie_data
        end

        #Now I'd have to stub this to access the controller...

        # binding.pry

        #Opt: stub an empty reply - verify it's [] (separate test)
      end
    end

    context "sad path (request invalid / edge cases)" do

    end
  end

end
