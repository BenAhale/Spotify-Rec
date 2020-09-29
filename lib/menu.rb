class Menu
  def initialize(user)
    @user = user
    @prompt = prompt = TTY::Prompt.new
    @playlist = Playlist.new(@user)
  end

  def display_menu
    system('clear')
    @prompt.select("》  MAIN MENU  《\n".colorize(:light_green), ['My List', 'Recommendations', 'Playlist', 'Account Details', 'Exit'])
  end

  def my_list
    system('clear')
    selection = @prompt.select("》  MY LIST  《\n".colorize(:light_green), %w[Display Add Remove Back])
    mylist = MyList.new(@user)
    case selection
    when 'Display'
      mylist.list
    when 'Add'
      mylist.add_to_list
    when 'Remove'
      mylist.remove_from_list
    when 'Back'
      menu_router
    end
  end

  def account_details
    system('clear')
    selection = @prompt.select("》  ACCOUNT MENU  《 \n".colorize(:light_green), ['View Details', 'Change Username', 'Change Password', 'Delete Account', 'Back'])
    case selection
    when 'View Details'
      @user.details
    when 'Change Username'
      username = @prompt.ask('Please enter your new username >') { |u| u.validate(/\A[0-9a-zA-Z'-]*\z/, 'Username must only contain letters and numbers')}
      @user.change_username(username)
    when 'Change Password'
      password = @prompt.ask('Please enter your new password >')
      @user.change_password(password)
    when 'Delete Account'
      @user.delete_account
    when 'Back'
      menu_router
    end
  end

  def menu_router
    selection = display_menu
    case selection
    when 'My List'
      system('clear')
      my_list
    when 'Recommendations'
      recommendation = Rec.new(@user)
      recommendation.amount_of_suggestions
    when 'Playlist'
      @playlist.menu
    when 'Account Details'
      account_details
    when 'Exit'
      exit
    end
  end
end
