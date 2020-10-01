# frozen_string_literal: true

require_relative 'menu'

module Login
  @prompt = TTY::Prompt.new
  @count = 0

  # Login Logic Section
  # Prompts the user to indicate whether they are a new or returning user
  def initial_login
    clear
    ascii_art
    puts '》  Welcome to the Spotify Recommendations App!  《'.colorize(:light_green)
    puts
    selection = @prompt.select("Are you a new or returning user? \n", %w[New Returning])
    new_user if selection == 'New'
    returning_user if selection == 'Returning'
  end

  # New user
  # Prompts user to enter username for new account. Checks name for any special characters.
  # Raises error if special character is included, and prompts the user again.
  def new_user
    system('clear')
    File.open(userdata, 'w') { |f| f.write([].to_json) } unless File.exist?(userdata)
    puts 'Welcome! Please register for an account to continue.'.colorize(:light_green)
    username = @prompt.ask('Username >')
    raise RequirementError.new, 'Requirements not met' if username.match?(/[!@#$%^&*(),.?":{}|<>]/)

    new_user_password(username)
  rescue RequirementError
    puts 'Username cannot contain special characters. Please try again!'.colorize(:light_red)
    new_user
  end

  # Prompts for new password. Validates password so no special characters are included.
  def new_user_password(username)
    password = @prompt.mask('Password >')
    raise RequirementError.new, 'Requirements not met' if password.match?(/[!@#$%^&*(),.?":{}|<>]/)

    @user = User.new(username, password, gen_uid)
    @user_playlist = Playlist.new(@user)
    store_user
  rescue RequirementError
    puts 'Password cannot contain special characters. Please try again!'.colorize(:light_red)
  end

  # Converts user details into a hash, ready to be stored in JSON file
  def store_user
    data = load_data
    user_details = {
      'id' => @user.uid.to_s,
      'username' => @user.username,
      'password' => @user.password,
      'playlist' => @user.playlist,
      'mylist' => @user.mylist
    }
    data << user_details
    write_user(data)
  end

  # Writes the hash of user data to the JSON file
  def write_user(data)
    File.open(userdata, 'w') do |f|
      f.puts JSON.pretty_generate(data)
    end
    puts "You're now registered! Logging you in..".colorize(:light_green)
    sleep(1)
    go_to_menu
  end

  # Returning user
  # Prompts user to enter username and password
  def returning_user
    system('clear')
    File.open(userdata, 'w') { |f| f.write([].to_json) } unless File.exist?(userdata)
    puts 'Welcome back! Please login to continue.'.colorize(:light_green)
    username = @prompt.ask('Username >')
    user_password = @prompt.mask('Password >')
    authenticate(username, user_password)
  end

  # Loads data from JSON file
  def authenticate(username, user_password)
    data_arr = load_data
    user_data(data_arr, username, user_password)
  end

  # Checks whether supplied username and password match any in the userfile
  def user_data(data, username, user_password)
    data.each do |hash|
      next unless hash['username'].downcase == username.downcase

      next unless hash['password'] == user_password

      @user = User.new(username, user_password, hash['id'], hash['playlist'], hash['mylist'])
      go_to_menu
    end
    @count += 1
    no_auth
  end

  # Method exits application if user is unsuccessful 3 times or more. Otherwise returns to login
  def no_auth
    puts 'Incorrect username or password!'.colorize(:red)
    sleep(1)
    if @count >= 3
      puts 'You have tried too many times! The application will now close..'.colorize(:light_red)
      exit
    end
    returning_user
  end

  # Helper Module Methods
  def user
    @user
  end

  def gen_uid
    load_data.length + 1
  end

  def userdata
    path = File.join(File.dirname(File.dirname(File.absolute_path(__FILE__))))
    "#{path}/public/users.json"
  end

  def load_data
    file = File.read(userdata)
    JSON.parse(file)
  end

  def clear
    system('clear')
  end

  def go_to_menu
    menu = Menu.new(@user)
    menu.menu_router
  end

  def ascii_art
    puts "               ;;;;;;;;;;;;;;;;;;;
               ;                 ;
               ;                 ;
               ;                 ;
               ;                 ;
               ;                 ;
           ,;;;;;            ,;;;;;
           ;;;;;;            ;;;;;;
           `;;;;'            `;;;;'\n".colorize(:light_green)
  end
end
