module Rec

  @tracks = []
  @artists = []
  @genres = []

  def sort_my_list
    list = $user.mylist.clone
    list.each do |item|
      @tracks << item["id"] if item["type"] == "track"
      @artists << item["id"] if item["type"] == "artist"
      @genres << item["name"].downcase if item["type"] == "genre"
    end
  end

  def update_file
    updated_data = Login.load_data.each { |user| user["playlist"] = $user.playlist if user["id"] == $user.uid.to_s }
    File.open(userdata,"w") do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
    puts "Sweet! Your list has been updated!"
    $prompt.keypress("Press any key to return to the previous menu..")
    Menu::menu_router
  end

  def clean_recommendations(selections)
    selections.each do |track|
      details = track.split(" by ")
      song = RSpotify::Track.search("#{details[0]} #{details[1]}", limit: 1).first
      song_details = {
        "name" => song.name,
        "id" => song.id,
        "artist" => song.artists[0].name }
      $user.playlist << song_details
    end
    update_file
  end

  def recommend(num)
    prompt = TTY::Prompt.new
    sort_my_list
    recommendations = RSpotify::Recommendations.generate(limit: num, seed_artists: @artists, seed_genres: @genres, seed_tracks: @tracks)
    cleaned_recs = recommendations.tracks.map { |t| "#{t.name} by #{t.artists[0].name}" }
    selections = prompt.multi_select("Select any number of suggestions to add to your playlist!", cleaned_recs)
    clean_recommendations(selections)
  end

  def amount_of_suggestions
    prompt = TTY::Prompt.new
    amount = prompt.ask("How many suggestions would you like to generate?") do |q|
      q.in '1-10'
      q.messages[:range?] = "Number must be between 1 and 10"
    end
    recommend(amount)
  end


end