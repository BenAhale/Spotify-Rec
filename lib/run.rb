# require 'rspotify'
require_relative 'user'
# require_relative 'playlist'
require_relative 'login'
require 'json'
require "tty-prompt"
require_relative 'menu'
# require_relative 'top_10'
include Login
include Menu
# include Top10

# RSpotify.authenticate("712ff89a218a4e6dbe1f169e06f949b9", "e9e0517f405b4a01a1be8823126459b7")
# track = RSpotify::Track.search('Giants Dermot Kennedy').first
# recommendations = RSpotify::Recommendations.generate(limit: 10, seed_tracks: [track.id], seed_genres: ["pop"])

# recommendations.tracks.each do |t|
#   puts t.name
# end

Login::login
# Menu::menu_router