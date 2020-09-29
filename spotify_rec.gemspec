# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'spotify_rec'
  s.version = '1.1'
  s.date = '2020-09-28'
  s.summary = 'Spotify Rec generates track recommendations based upon a user defined list of items'
  s.files = [
    'lib/login.rb',
    'lib/menu.rb',
    'lib/my_list.rb',
    'lib/playlist.rb',
    'lib/rec.rb',
    'lib/run.rb',
    'lib/user.rb',
    'public/users.json'
  ]
  s.require_paths = %w[lib public]
  s.authors = ['Ben Ahale']
  s.executables << 'spotify_rec'
  s.required_ruby_version = '>= 2.4'
end
