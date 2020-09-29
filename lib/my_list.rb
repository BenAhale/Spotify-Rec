# frozen_string_literal: true

class MyList
  def initialize(user)
    @user = user
    @mylist = user.mylist
    @menu = Menu.new(@user)
    @prompt = TTY::Prompt.new
  end

  # Display MyList

  def list
    raise MyListEmpty.new, 'List must not be empty' if @mylist.empty?

    list_table
    @prompt.keypress('Press any key to return to the previous menu..')
    @menu.my_list
  rescue MyListEmpty
    empty_list
  end

  def list_table
    rows = @mylist.map do |hash|
      if hash['type'] == 'track' || hash['type'] == 'album'
        ["#{hash['name']} by #{hash['artist']}", hash['type'].capitalize]
      else
        [hash['name'], hash['type'].capitalize]
      end
    end
    table = Terminal::Table.new headings: %w[Item Type], rows: rows
    puts table
  end

  def empty_list
    puts 'Oh no! Your list is currently empty!'.colorize(:light_red)
    puts 'Add up to 5 items to your list. An item can be a song, artist or genre.'.colorize(:light_red)
    puts
    @prompt.keypress('Press any key to return to the previous menu..')
    @menu.my_list
  end

  # Add to MyList

  def add_to_list
    list_too_long if @mylist.length >= 5
    selection = @prompt.select('Which type would you like to add?'.colorize(:light_green), %w[Song Artist Genre Back])
    case_add_to_list(selection)
  end

  def list_too_long
    puts "Oh no! You've reached maximum capacity in your list! You won't be able to add".colorize(:light_red)
    puts 'another item until you remove an existing one.'.colorize(:light_red)
    puts "You can do this by heading back to the previous menu, and selecting 'Remove'".colorize(:light_red)
    @prompt.keypress('Press any key to return to the previous menu..')
    @menu.my_list
  end

  def case_add_to_list(selection)
    case selection
    when 'Song'
      search_song
    when 'Artist'
      search_artist
    when 'Genre'
      store_genre
    when 'Back'
      @menu.my_list
    end
  end

  def search_song
    song_query = @prompt.ask('What is the name of the song?'.colorize(:light_green))
    tracks = RSpotify::Track.search(song_query, limit: 5)
    cleaned_results = []
    tracks.each { |t| cleaned_results << "#{t.name} by #{t.artists[0].name}" }
    system('clear')
    cleaned_results << 'Back'
    selection = @prompt.select('Please select one of the search results:', cleaned_results).split(' by ')
    add_to_list if selection[0] == 'Back'
    store_song(selection)
  end

  def store_song(details)
    track = RSpotify::Track.search("#{details[0]} #{details[1]}", limit: 1).first
    song_details = {
      'name' => track.name,
      'artist' => track.artists[0].name,
      'id' => track.id,
      'type' => 'track'
    }
    @mylist << song_details
    update_file
  end

  def search_artist
    artist_query = @prompt.ask('What is the name of the artist?'.colorize(:light_green))
    artists = RSpotify::Artist.search(artist_query, limit: 5)
    cleaned_results = []
    artists.each { |a| cleaned_results << a.name.to_s }
    system('clear')
    selection = @prompt.select('Please select one of the search results:', cleaned_results)
    store_artist(selection)
  end

  def store_artist(details)
    artist = RSpotify::Artist.search(details.to_s, limit: 1).first
    artist_details = {
      'name' => artist.name,
      'id' => artist.id,
      'type' => 'artist'
    }
    @mylist << artist_details
    update_file
  end

  def store_genre
    genres = RSpotify::Recommendations.available_genre_seeds
    genre = @prompt.select('Which genre would you like to add to your list?', genres, filter: true)
    genre_details = {
      'name' => genre.capitalize,
      'type' => 'genre'
    }
    @mylist << genre_details
    update_file
  end

  # Remove From MyList

  def remove_from_list
    empty_list if @mylist.length <= 0
    item_names = @mylist.map { |item| item['name'] }
    item_names << 'Back'
    selection = @prompt.select('Which item would you like to remove?'.colorize(:light_green), item_names)
    @menu.my_list if selection == 'Back'
    @mylist.each_with_index do |item, index|
      @mylist.delete_at(index) if item['name'] == selection
    end
    update_file
  end

  # Update userfile

  def update_file
    updated_data = Login.load_data.each { |user| user['mylist'] = @mylist if user['id'] == @user.uid.to_s }
    File.open(userdata, 'w') do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
    puts 'Sweet! Your list has been updated!'.colorize(:light_green)
    @prompt.keypress('Press any key to return to the previous menu..')
    @menu.my_list
  end
end
