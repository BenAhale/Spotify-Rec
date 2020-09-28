Gem::Specification.new do |s|
    s.name = %q{spotify_rec}
    s.version = "1.0"
    s.date = %q{2020-09-28}
    s.summary = %q{Spotify Rec generates track recommendations based upon a user defined list of items}
    s.files = [
      "lib/login.rb",
      "lib/menu.rb",
      "lib/my_list.rb",
      "lib/playlist.rb",
      "lib/rec.rb",
      "lib/run.rb",
      "lib/user.rb",
      "public/users.json"
    ]
    s.require_paths = ["lib", "public"]
    s.authors  = ["Ben Ahale"]
    s.executables << 'spotify_rec'
  end