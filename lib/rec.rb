# frozen_string_literal: true

class Rec
  def initialize(user)
    @user_list = user.mylist
    @user = user
    @tracks = []
    @artists = []
    @genres = []
    @prompt = TTY::Prompt.new
  end

  # Prompts user to choose how many suggestions to generate
  def amount_of_suggestions
    system('clear')
    puts '》  RECOMMENDATIONS  《'
    amount = @prompt.ask('How many recommendations would you like to generate?'.colorize(:light_green)) do |q|
      q.in '1-10'
      q.messages[:range?] = 'Number must be between 1 and 10'
    end
    recommend(amount.to_i)
  end

  # Prompts user to select which recommendations to add to their playlist
  def recommend(num)
    system('clear')
    recommendations = recommendations_generate(num)
    cleaned_recs = recommendations.tracks.map { |t| "#{t.name} by #{t.artists[0].name}" }
    puts '》  RECOMMENDATIONS  《'.colorize(:light_green)
    puts 'Select the recommendations you want to add to your playlist!'
    selections = @prompt.multi_select('Hit enter with none selected to skip.', cleaned_recs)
    clean_recommendations(selections)
  end

  # Sorts list items into arrays to be used in generating recommendations
  def sort_my_list
    @tracks.clear
    @artists.clear
    @genres.clear
    @user_list.each do |item|
      @tracks << item['id'] if item['type'] == 'track'
      @artists << item['id'] if item['type'] == 'artist'
      @genres << item['name'].downcase if item['type'] == 'genre'
    end
  end

  # Generates recommendations with RSpotify
  def recommendations_generate(num)
    sort_my_list
    RSpotify::Recommendations.generate(limit: num, seed_artists: @artists, seed_genres: @genres, seed_tracks: @tracks)
  end

  # Searches again for song selections to get the track object rather than just the name and artist
  def clean_recommendations(selections)
    selections.each do |track|
      details = track.split(' by ')
      song = RSpotify::Track.search("#{details[0]} #{details[1]}", limit: 1).first
      song_details(song)
    end
    update_file
  end

  # Pulls song details from track and stores in a hash. Pushes to user playlist array
  def song_details(song)
    song_details = {
      'name' => song.name,
      'id' => song.id,
      'artist' => song.artists[0].name
    }
    @user.playlist << song_details
  end

  # Updates file with current user playlist
  def update_file
    updated_data = Login.load_data.each { |user| user['playlist'] = @user.playlist if user['id'] == @user.uid.to_s }
    File.open(userdata, 'w') do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
    puts 'Sweet! Your list has been updated!'.colorize(:light_green)
    @prompt.keypress('Press any key to return to the previous menu..')
    menu = Menu.new(@user)
    menu.menu_router
  end
end
