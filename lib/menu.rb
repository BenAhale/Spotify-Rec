module Menu

  def display_menu
    system("clear")
    prompt = TTY::Prompt.new
    return prompt.select("    MENU", (["My List", "Generate Suggestions", "Playlist", "Edit Account Details", "Exit"]))
  end

  def my_list
    system("clear")
    prompt = TTY::Prompt.new
    selection = prompt.select("--==+ My List +==--", (["Display", "Add", "Remove", "Back"]))
    case selection
      when "Display"
        MyList::list
      when "Add"
        MyList::add_to_list
      when "Remove"
        MyList::remove_from_list
      when "Back"
        menu_router
    end
  end

  def menu_router
    selection = display_menu
    case selection
      when "My List"
        system("clear")
        my_list
      when "Generate Suggestions"
        Rec::amount_of_suggestions
      when "Playlist"
        UserPlaylist::menu
      when "Edit Account Details"
        puts "Account Details Selected"
      when "Exit"
        exit
    end
  end

end