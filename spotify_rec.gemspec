# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'spotify_rec'
  s.version = '1.5'
  s.date = '2020-10-01'
  s.summary = 'Spotify Rec generates track recommendations based upon a user defined list of items'
  s.files = [
    'lib/login.rb',
    'lib/menu.rb',
    'lib/my_list.rb',
    'lib/playlist.rb',
    'lib/rec.rb',
    'lib/user.rb',
    'lib/tutorial.rb',
    'lib/error.rb',
    'public/users.json',
    'lib/spec/rec_spec.rb',
    'lib/spec/user_spec.rb'
  ]
  s.require_paths = %w[lib public]
  s.authors = ['Ben Ahale']
  s.executables << 'spotify_rec'
  s.required_ruby_version = '>= 2.4'
  s.add_runtime_dependency 'tty-prompt'
  s.add_runtime_dependency 'terminal-table'
  s.add_runtime_dependency 'rspotify'
  s.add_runtime_dependency 'colorize'
end