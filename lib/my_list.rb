module MyList

  $prompt = TTY::Prompt.new

  def list
    unless $user.mylist.empty?
      $user.mylist.each do |hash|
        if hash["type"] == "track" || hash["type"] == "album"
          puts "#{hash["name"]} by #{hash["artist"]} || #{hash["type"].capitalize}"
        else
          puts "#{hash["name"]} || #{hash["type"].capitalize}"
        end
      end
      puts "--------------------------"
      sleep(1)
      add_to_list
    else
      empty_list
    end
  end

  def empty_list
    puts "Your list is currently empty! Let's fix that up now."
    puts "Add up to 5 items to your list. An item can be a song, artist, album or genre."
    add_to_list
  end

  def add_to_list
    if $user.mylist.length >= 5
      puts "You've reached maximum capacity in your list! You won't be able to add another item until you remove an existing one."
      exit
    end
    selection = $prompt.select("Which type would you like to add?", (["Song", "Artist", "Album", "Genre"]))
    case selection
      when "Song"
        search_song
      when "Artist"
        search_artist
      when "Album"
        search_album
      when "Genre"
        p RSpotify::Recommendations.available_genre_seeds
    end
  end

  def remove_from_list

  end

  def search_song
    song_query = $prompt.ask("What is the name of the song?")
    tracks = RSpotify::Track.search(song_query, limit: 5)
    cleaned_results = []
    tracks.each { |t| cleaned_results << "#{t.name} by #{t.artists[0].name}" }
    system("clear")
    selection = $prompt.select("Please select one of the search results:", (cleaned_results)).split(" by ")
    store_song(selection)
  end

  def store_song(details)
    track = RSpotify::Track.search("#{details[0]} #{details[1]}", limit: 1).first
    song_details = {
    "name" => track.name,
    "artist" => track.artists[0].name,
    "id" => track.id,
    "type" => "track"
    }
    $user.mylist << song_details
    update_file
  end

  def search_album
    album_query = $prompt.ask("What is the name of the album?")
    albums = RSpotify::Album.search(album_query, limit: 5)
    cleaned_results = []
    albums.each { |a| cleaned_results << "#{a.name} by #{a.artists[0].name}" }
    system("clear")
    selection = $prompt.select("Please select one of the search results:", (cleaned_results)).split(" by ")
    store_album(selection)
  end

  def store_album(details)
    album = RSpotify::Album.search("#{details[0]} #{details[1]}", limit: 1).first
    album_details = {
    "name" => album.name,
    "artist" => album.artists[0].name,
    "id" => album.id,
    "type" => "album"
    }
    $user.mylist << album_details
    update_file
  end

  def search_artist
    artist_query = $prompt.ask("What is the name of the album?")
    artists = RSpotify::Artist.search(artist_query, limit: 5)
    cleaned_results = []
    artists.each { |a| cleaned_results << "#{a.name}" }
    system("clear")
    selection = $prompt.select("Please select one of the search results:", (cleaned_results))
    store_artist(selection)
  end

  def store_artist(details)
    artist = RSpotify::Artist.search("#{details}", limit: 1).first
    artist_details = {
    "name" => artist.name,
    "id" => artist.id,
    "type" => "artist"
    }
    $user.mylist << artist_details
    update_file
  end

  def update_file
    updated_data = Login.load_data.each { |user| user["mylist"] = $user.mylist if user["id"] == $user.uid.to_s }
    File.open(userdata,"w") do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
  end

end