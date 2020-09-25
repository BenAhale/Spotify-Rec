class Playlist

  attr_reader :tracks

  def initialize(tracks)
    @tracks = tracks
  end

  def add_track(track)
    @tracks << track
  end

  def add_multiple_tracks(tracks)
    tracks.each { |track| @tracks << track }
  end

  def list
    @tracks.each { |track| puts "#{track["name"]} by #{track["artist"]}" }
  end
end

module UserPlaylist

  def remove
    empty if $user.playlist.length <= 0
    item_names = $user.playlist.map { |item| "#{item["name"]} by #{item["artist"]}" }
    item_names << "Back"
    selection = $prompt.select("Which track would you like to remove?", (item_names)).split(" by ")
    menu if selection == "Back"
    $user.playlist.each_with_index do |item, index|
      $user.playlist.delete_at(index) if item["name"] == selection[0]
    end
    update_playlist
  end

  def empty
    puts "Oh no! Your playlist is currently empty!"
    puts "You can add songs manually from the previous menu, or generate recommendations and add those!"
    separator
    $prompt.keypress("Press any key to return to the previous menu..")
    Menu::my_list
  end

  def add
    song_query = $prompt.ask("What is the name of the song?")
    tracks = RSpotify::Track.search(song_query, limit: 5)
    cleaned_results = []
    tracks.each { |t| cleaned_results << "#{t.name} by #{t.artists[0].name}" }
    system("clear")
    cleaned_results << "Back"
    selection = $prompt.select("Please select one of the search results:", (cleaned_results)).split(" by ")
    menu if selection[0] == "Back"
    store(selection)
  end

  def store(details)
    track = RSpotify::Track.search("#{details[0]} #{details[1]}", limit: 1).first
    song_details = {
    "name" => track.name,
    "id" => track.id,
    "artist" => track.artists[0].name
    }
    $user.playlist << song_details
    update_playlist
  end

  def update_playlist
    updated_data = Login.load_data.each { |user| user["playlist"] = $user.playlist if user["id"] == $user.uid.to_s }
    File.open((Login::userdata),"w") do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
    puts "Sweet! Your playlist has been updated!"
    $prompt.keypress("Press any key to return to the previous menu..")
    menu
  end

  def menu
    prompt = TTY::Prompt.new
    selection = prompt.select("What would you like to do?", (%w[Display Add Remove Back]))
    case selection
      when "Display"
        $user_playlist.list
        sleep(3)
        menu
      when "Add"
        add
        menu
      when "Remove"
        remove
        menu
      when "Back"
        Menu::menu_router
    end
  end

end