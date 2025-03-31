require "rails_helper"

RSpec.describe "Movies API", type: :request do
  describe "List top-rated movies" do
    context "happy path (request valid)" do
      it "contains correct fields", :vcr do
        #Need to setup mocking / stubbing ASAP now that I know it's working

        #A complication: how to stub 'nested' request
        get api_v1_movies_path
        movies_json = JSON.parse(response.body, symbolize_names: true)

        # binding.pry

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

      it "lists a maximum of 20 movies" do
        movies_data = []
        25.times do |i|
          misc_movie_data = {
            id: i,
            title: "Some movie #{i}",
            vote_average: i % 10
          }

          movies_data << misc_movie_data
        end

        #Stub TMDB for appropriate response in controller
        stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated").to_return(status: 200, body: ({ results: movies_data }).to_json)
        get api_v1_movies_path

        misc_movies_json = JSON.parse(response.body, symbolize_names: true)
        expect(misc_movies_json[:data]).to be_a(Array)
        expect(misc_movies_json[:data].length).to eq(20)
      end
    end

    context "sad path (request invalid / edge cases)" do

    end
  end

  describe "List movies based on title name search" do
    context "happy path (request valid)" do
      xit "returns appropriately formatted list", :vcr do

        #NOTE: can't get VCR to work correctly here.  Maybe b/c parameters / non-deterministic aspects?
        #Ask tomorrow AM...

        get "#{api_v1_movies_path}?search=rings"
        filtered_movies_json = JSON.parse(response.body, symbolize_names: true)

        binding.pry

        expect(response).to be_successful

        expect(filtered_movies_json).to have_key(:data)
        expect(filtered_movies_json[:data]).to be_a(Array)

        filtered_movies_json[:data].each do |movie_data|
          expect(movie_data).to have_key(:id)
          expect(movie_data).to have_key(:type)
          expect(movie_data[:type]).to eq("movie")
          expect(movie_data).to have_key(:attributes)
          expect(movie_data[:attributes]).to have_key(:title)
          expect(movie_data[:attributes]).to have_key(:vote_average)
        end
      end

      xit "returns correct lists (2 examples), and limited to 20 entries", :vcr do
        get "#{api_v1_movies_path}?search=lord of the rings"
        filtered_movies_json = JSON.parse(response.body, symbolize_names: true)

        expect(filtered_movies_json.length).to eq()
        #Find the LOTR series in here! (Trying to be clever, heh)
        title_endings = ["Fellowship", "Two Towers", "King"]
        results = filtered_movies_json[:results].find_all do |movie|
          title_endings.any do |title_ending|
            movie[:attributes][:title].include?(title_ending)
          end
        end
        expect(results.length).to eq(3)

        get "#{api_v1_movies_path}?search=action"
        filtered_movies_json = JSON.parse(response.body, symbolize_names: true)

        expect(filtered_movies_json[:results].length).to eq(20)
      end
    end

    context "sad path (request invalid / edge cases)" do
      it "" do
        #Query parameter not present (probably will need to change API endpoint to ./movies/search or something)
      end
    end

  end

  describe "Shows details for a specified movie" do
    it "correctly returns all movie details" do
      specified_movie_id = 278    #Shawshank Redemption at TMDB (unless they reorder the IDs!)
      get api_v1_movie_path(specified_movie_id)
      movie_details = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      #General structure
      expect(movie_details).to have_key(:data)
      expect(movie_details[:data]).to have_key(:id)
      expect(movie_details[:data][:id]).to eq(specified_movie_id)
      expect(movie_details[:data]).to have_key(:type)
      expect(movie_details[:data][:type]).to eq("movie")
      expect(movie_details[:data]).to have_key(:attributes)
      expect(movie_details[:data][:attributes]).to have_key(:title)
      expect(movie_details[:data][:attributes]).to have_key(:release_year)
      expect(movie_details[:data][:attributes]).to have_key(:vote_average)
      expect(movie_details[:data][:attributes]).to have_key(:runtime)
      expect(movie_details[:data][:attributes]).to have_key(:genres)
      expect(movie_details[:data][:attributes][:genres]).to be_a(Array)
      expect(movie_details[:data][:attributes]).to have_key(:summary)
      

      #Cast details, including limit to 10
      expect(movie_details[:data][:attributes]).to have_key(:cast)
      expect(movie_details[:data][:attributes][:cast]).to be_a(Array)
      expect(movie_details[:data][:attributes][:cast].length).to eq(10)
      movie_details[:data][:attributes][:cast].each do |cast_member|
        expect(cast_member).to be_a(Hash)
        expect(cast_member).to have_key(:character)
        expect(cast_member).to have_key(:actor)
      end

      #Reviews details, including limit to 5
      expect(movie_details[:data][:attributes]).to have_key(:total_reviews)
      expect(movie_details[:data][:attributes][:total_reviews]).to be_a(Integer)
      expect(movie_details[:data][:attributes]).to have_key(:reviews)
      expect(movie_details[:data][:attributes][:reviews]).to be_a(Array)
      expect(movie_details[:data][:attributes][:reviews].length).to eq(5)
      movie_details[:data][:attributes][:reviews].each do |reviewer|
        expect(reviewer).to be_a(Hash)
        expect(reviewer).to have_key(:author)
        expect(reviewer).to have_key(:review)
      end
    end

    #Should probably do sad path if movie ID doesn't exist via TMDB API call...

  end

end
