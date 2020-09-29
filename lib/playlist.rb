# frozen_string_literal: true

class Playlist
  attr_reader :tracks

  def initialize(user)
    @user = user
    @playlist = user.playlist
    @prompt = TTY::Prompt.new
  end

  def list
    puts '》  PLAYLIST  《'
    rows = @playlist.map { |track| [track['name'], track['artist']] }
    table = Terminal::Table.new headings: %w[Track Artist], rows: rows
    puts table
    keypress_playlist
    menu
  end

  def remove
    empty if @playlist.length <= 0
    item_names = @playlist.map { |item| "#{item['name']} by #{item['artist']}" }
    item_names << 'Back'
    selection = @prompt.select('Which track would you like to remove?', item_names).split(' by ')
    menu if selection == 'Back'
    @playlist.each_with_index do |item, index|
      @user.playlist.delete_at(index) if item['name'] == selection[0]
    end
    update_playlist
  end

  def empty
    puts 'Oh no! Your playlist is currently empty!'
    puts 'You can add songs manually from the previous menu, or generate recommendations and add those!'
    separator
    @prompt.keypress('Press any key to return to the previous menu..')
    menu
  end

  def add
    song_query = @prompt.ask('What is the name of the song?')
    tracks = RSpotify::Track.search(song_query, limit: 5)
    cleaned_results = []
    tracks.each { |t| cleaned_results << "#{t.name} by #{t.artists[0].name}" }
    system('clear')
    cleaned_results << 'Back'
    selection = @prompt.select('Please select one of the search results:', cleaned_results).split(' by ')
    menu if selection[0] == 'Back'
    store(selection)
  end

  def store(details)
    track = RSpotify::Track.search("#{details[0]} #{details[1]}", limit: 1).first
    song_details = {
      'name' => track.name,
      'id' => track.id,
      'artist' => track.artists[0].name
    }
    @playlist << song_details
    update_playlist
  end

  def update_playlist
    updated_data = Login.load_data.each { |user| user['playlist'] = @playlist if user['id'] == @user.uid.to_s }
    File.open(Login.userdata, 'w') do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
    puts 'Sweet! Your playlist has been updated!'
    @prompt.keypress('Press any key to return to the previous menu..')
    menu
  end

  def export_to_file
    path = File.join(File.dirname(File.dirname(File.absolute_path(__FILE__))))
    File.open("#{path}/playlist.md", 'w') do |f|
      f.puts("# #{@user.username}'s Playlist")
      @playlist.each do |track|
        link = "[Listen on Spotify](https://open.spotify.com/track/#{track['id']})"
        f.puts("1. #{track['name']} by #{track['artist']} #{link}")
      end
    end
    copy_to_desktop(path)
  end

  def copy_to_desktop(path)
    system("cp #{path}/playlist.md ~/Desktop/playlist.md")
    puts 'Exported playlist to your Desktop!'
    @prompt.keypress('Press any key to return to the previous menu..')
    menu
  end

  def keypress_playlist
    @prompt.keypress('Press any key to return to the previous menu..')
  end

  def menu
    system('clear')
    selection = @prompt.select('》  PLAYLIST  《', ['Display', 'Add', 'Remove', 'Export To File', 'Back'])
    case selection
    when 'Display'
      list
    else
      case_menu(selection)
    end
  end

  def case_menu(selection)
    case selection
    when 'Add'
      add
    when 'Remove'
      remove
    else
      second_case_menu(selection)
    end
  end

  def second_case_menu(selection)
    case selection
    when 'Export To File'
      export_to_file
    when 'Back'
      menu = Menu.new(@user)
      menu.menu_router
    end
  end
end
