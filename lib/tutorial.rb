# frozen_string_literal: true

# Contains methods to display tutorial screens
module Tutorial
  @prompt = TTY::Prompt.new

  def start
    system('clear')
    puts '》  WELCOME TO SPOTIFY REC  《'.colorize(:light_green)
    puts 'This tutorial will walk you through the basics to using the app.'
    puts "There are 3 main areas that you'll need to understand:"
    puts '- My List'
    puts '- Recommendations'
    puts '- Playlist'
    puts
    @prompt.keypress('Press any key to continue..')
    my_list
  end

  def my_list
    system('clear')
    puts '》  MY LIST  《'.colorize(:light_green)
    puts 'My List is the base that your recommendations are generated from. It can consist of'
    puts "up to 5 of any 'items'. An item is either a track, artist or genre. You can add and remove"
    puts 'items from my list, so make sure to change them up regularly to get a range of recommendations!'
    puts "Searching for an item will return the top 5 results for your keywords, so if yours doesn't show"
    puts 'up, try searching again with a more specific query!'
    puts
    @prompt.keypress('Press any key to continue..')
    recommendations
  end

  def recommendations
    system('clear')
    puts '》  RECOMMENDATIONS  《'.colorize(:light_green)
    puts 'As mentioned on the previous screen, recommendations are tracks, and are generated based on the'
    puts "items in your list. You can select the amount you'd like to generate, and select any number of"
    puts 'the recommendations to store in your playlist. Recommendations are capped at 10 per generate,'
    puts 'but you can repeat the generate step as many times as you would like.'
    puts
    @prompt.keypress('Press any key to continue..')
    playlist
  end

  def playlist
    system('clear')
    puts '》  PLAYLIST 《'.colorize(:light_green)
    puts "Your playlist stores all of the recommendations you've chosen, but you can also manually add and"
    puts "remove songs as well. This can all be done from the playlist menu. At any point you'd like to look"
    puts 'at your playlist outside of Spotify Rec, you can export the contents to a file on your desktop.'
    puts 'This file includes a link to each song on Spotify, so you can easily go and start listening!'
    puts
    @prompt.keypress('Press any key to return to finish..')
    exit
  end
end
