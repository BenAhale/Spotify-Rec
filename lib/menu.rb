# frozen_string_literal: true

class Menu
  def initialize(user)
    @user = user
    @prompt = TTY::Prompt.new
    @playlist = Playlist.new(@user)
  end

  def display_menu
    system('clear')
    arr = ['My List', 'Recommendations', 'Playlist', 'Account Details', 'Exit']
    @prompt.select("》  MAIN MENU  《\n".colorize(:light_green), arr)
  end

  def my_list
    system('clear')
    selection = @prompt.select("》  MY LIST  《\n".colorize(:light_green), %w[Display Add Remove Back])
    mylist = MyList.new(@user)
    case_my_list(selection, mylist)
  end

  def case_my_list(selection, mylist)
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

  def account_details_selection
    system("clear")
    arr = ["View Details", "Change Username", "Change Password", "Delete Account", "Back"]
    @prompt.select("》  ACCOUNT DETAILS  《\n".colorize(:light_green), arr)
  end

  def account_details
    selection = account_details_selection
    case selection
    when 'View Details'
      @user.details
    when 'Change Username'
      username = @prompt.ask('Please enter your new username >')
      @user.change_username(username)
    else
      second_details(selection)
    end
  end

  def second_details(selection)
    case selection
    when 'Change Password'
      password = @prompt.ask('Please enter your new password >')
      @user.change_password(password)
    when 'Delete Account'
      @user.delete_account
    when 'Back'
      menu_router
    end
  end

  def second_menu(selection)
    case selection
    when 'Playlist'
      @playlist.menu
    when 'Account Details'
      account_details
    when 'Exit'
      exit
    else
      puts "End of second menu"
    end
  end

  def menu_router
    puts "Do we get here? Menu"
    selection = display_menu
    selection_two = selection
    case selection
    when 'My List'
      my_list
    when 'Recommendations'
      recommendation = Rec.new(@user)
      recommendation.amount_of_suggestions
    else
      second_menu(selection_two)
    end
  end
end
