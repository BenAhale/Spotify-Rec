require 'rspotify'
require 'optparse'
require 'json'
require 'tty-prompt'
require 'terminal-table'
require 'colorize'
require_relative 'user'
require_relative 'playlist'
require_relative 'login'
require_relative 'rec'
require_relative 'menu'
require_relative 'my_list'
include Login

RSpotify.authenticate("712ff89a218a4e6dbe1f169e06f949b9", "e9e0517f405b4a01a1be8823126459b7")
$prompt = TTY::Prompt.new

VERSION = 1.0

ARGV << '--run' if ARGV.empty?

options = {}
parser = OptionParser.new do |opts|
    opts.banner = "Welcome to Spotify Recommendations! Usage: spotifyrec [options]".colorize(:light_green)

    opts.on("-v", "--version", "Display the version") do
        puts "Spotify Recommendations version #{VERSION}".colorize(:light_green)
    end

    opts.on("-h", "--help", "Display the help message") do
        puts opts
        exit
    end

    opts.on("-qGENRE", "--quick=GENRE", "Generate a quick recommendation with the chosen genre") do |genre|
        recommendations = RSpotify::Recommendations.generate(limit: 5, seed_genres: [genre])
        cleaned_recs = recommendations.tracks.map { |t| "#{t.name} by #{t.artists[0].name}" }
        puts "》  RECOMMENDATIONS  《".colorize(:light_green)
        cleaned_recs.each { |track| puts track }
    end

    opts.on("-r", "--run", "Run the application") do
        Login::login
    end
end

parser.parse!