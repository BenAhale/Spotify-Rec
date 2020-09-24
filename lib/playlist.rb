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

  def menu
    prompt = TTY::Prompt.new
    selection = prompt.select("What would you like to do?", (%w[Display Add Remove Back]))
    case selection
      when "Display"
        $user_playlist.list
        sleep(3)
        menu
      when "Add"
        puts "Add coming soon!"
        menu
      when "Remove"
        puts "Remove coming soon!"
        menu
      when "Back"
        Menu::menu_router
    end
  end

end