# frozen_string_literal: true

class Menu
  def initialize(user)
    @user = user
    @prompt = TTY::Prompt.new
    @playlist = Playlist.new(@user)
    @list_length = @user.mylist.length
  end

  def display_menu
    system('clear')
    arr = ['My List', 'Recommendations', 'Playlist', 'Account Details', 'Exit']
    @prompt.select("》  MAIN MENU  《\n".colorize(:light_green), arr)
  end

  def menu_router
    selection = display_menu
    case selection
    when 'My List'
      my_list
    when 'Recommendations'
      recommendations_menu
    else
      case_menu(selection)
    end
  end

  def recommendations_menu
    if @list_length.positive?
      recommendation = Rec.new(@user)
      recommendation.amount_of_suggestions
    else
      no_items
    end
  end

  def no_items
    puts "Uh oh! You don't have any items in your list yet, so we can't generate any".colorize(:light_red)
    puts 'recommendations. Please add some before doing this!'.colorize(:light_red)
    @prompt.keypress('Press any key to return to the previous menu..')
    display_menu
  end

  def case_menu(selection)
    case selection
    when 'Playlist'
      @playlist.menu
    when 'Account Details'
      account_details
    when 'Exit'
      exit
    end
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

  def account_details_select
    system('clear')
    arr = ['View Details', 'Change Username', 'Change Password', 'Delete Account', 'Back']
    @prompt.select('》  ACCOUNT DETAILS  《\n'.colorize(:light_green), arr)
  end

  def account_details
    selection = account_details_select
    case selection
    when 'View Details'
      @user.details
    when 'Change Username'
      username = @prompt.ask('Please enter your new username >')
      @user.change_username(username)
    else
      case_account_details(selection)
    end
  end

  def case_account_details(selection)
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
end
