module Menu

  def display_menu
    system("clear")
    prompt = TTY::Prompt.new
    return prompt.select("》  MAIN MENU  《", (["My List", "Recommendations", "Playlist", "Account Details", "Exit"]))
  end

  def my_list
    system("clear")
    prompt = TTY::Prompt.new
    selection = prompt.select("》  MY LIST  《", (["Display", "Add", "Remove", "Back"]))
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

  def account_details
    system("clear")
    prompt = TTY::Prompt.new
    selection = prompt.select("》  ACCOUNT MENU  《", (["View Details", "Change Username", "Change Password", "Delete Account", "Back"]))
    case selection
      when "View Details"
        $user.details
      when "Change Username"
        username = prompt.ask("Please enter your new username >") { |u| u.validate(/\A[0-9a-zA-Z'-]*\z/, "Username must only contain letters and numbers")}
        $user.change_username(username)
      when "Change Password"
        password = prompt.ask("Please enter your new password >")
        $user.change_password(password)
      when "Delete Account"
        $user.delete_account
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
      when "Recommendations"
        Rec::amount_of_suggestions
      when "Playlist"
        UserPlaylist::menu
      when "Account Details"
        account_details
      when "Exit"
        exit
    end
  end

end