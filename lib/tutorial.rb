module Tutorial

  @prompt = prompt = TTY::Prompt.new

  def start
    system('clear')
    puts '》  WELCOME TO SPOTIFY REC  《'.colorize(:light_green)
    puts 'This tutorial will walk you through the basics to using the app.'.colorize(:light_green)
    puts "There are 3 main areas that you'll need to understand:".colorize(:light_green)
    puts '- My List'.colorize(:light_green)
    puts '- Recommendations'.colorize(:light_green)
    puts '- Playlist'.colorize(:light_green)
    puts
    @prompt.keypress('Press any key to continue..')
    my_list
  end

  def my_list
    system('clear')
    puts '》  MY LIST  《'.colorize(:light_green)
    puts 'My List is the base that your recommendations are generated from. It can consist of'.colorize(:light_green)
    puts "up to 5 of any 'items'. An item is either a track, artist or genre. You can add and remove".colorize(:light_green)
    puts 'items from my list, so make sure to change them up regularly to get a range of recommendations!'.colorize(:light_green)
    puts "Searching for an item will return the top 5 results for your keywords, so if yours doesn't show".colorize(:light_green)
    puts 'up, try searching again with a more specific query!'.colorize(:light_green)
    puts
    @prompt.keypress('Press any key to continue..')
    recommendations
  end

  def recommendations
    system('clear')
    puts '》  RECOMMENDATIONS  《'.colorize(:light_green)
    puts 'As mentioned on the previous screen, recommendations are tracks, and are generated based on the'.colorize(:light_green)
    puts "items in your list. You can select the amount you'd like to generate, and select any number of".colorize(:light_green)
    puts 'the recommendations to store in your playlist. Recommendations are capped at 10 per generate,'.colorize(:light_green)
    puts 'but you can repeat the generate step as many times as you would like.'.colorize(:light_green)
    puts
    @prompt.keypress('Press any key to continue..')
    playlist
  end

  def playlist
    system('clear')
    puts '》  PLAYLIST 《'.colorize(:light_green)
    puts "Your playlist stores all of the recommendations you've chosen, but you can also manually add and".colorize(:light_green)
    puts "remove songs as well. This can all be done from the playlist menu. At any point you'd like to look".colorize(:light_green)
    puts 'at your playlist outside of Spotify Rec, you can export the contents to a file on your desktop.'.colorize(:light_green)
    puts 'This file includes a link to each song on Spotify, so you can easily go and start listening!'.colorize(:light_green)
    puts
    @prompt.keypress('Press any key to return to finish..')
    exit
  end
end
