# frozen_string_literal: true

require_relative 'menu'

module Login
  @prompt = TTY::Prompt.new
  @count = 0

  # Login Logic Section
  def initial_login
    clear
    ascii_art
    puts '》  Welcome to the Spotify Recommendations App!  《'.colorize(:light_green)
    puts
    @prompt.select("Are you a new or returning user? \n", %w[New Returning])
  end

  def login
    new_returning = initial_login.downcase
    new_user if new_returning == 'new'
    returning_user if new_returning == 'returning'
  end

  # New user

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

  def new_user_password(username)
    password = @prompt.mask('Password >')
    raise RequirementError.new, 'Requirements not met' if password.match?(/[!@#$%^&*(),.?":{}|<>]/)

    @user = User.new(username, password, gen_uid)
    @user_playlist = Playlist.new(@user)
    store_user
  rescue RequirementError
    puts 'Password cannot contain special characters. Please try again!'.colorize(:light_red)
  end

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

  def write_user(data)
    File.open(userdata, 'w') do |f|
      f.puts JSON.pretty_generate(data)
    end
    puts "You're now registered! Logging you in..".colorize(:light_green)
    sleep(1)
    go_to_menu
  end

  # Returning user

  def returning_user
    system('clear')
    File.open(userdata, 'w') { |f| f.write([].to_json) } unless File.exist?(userdata)
    puts 'Welcome back! Please login to continue.'.colorize(:light_green)
    username = @prompt.ask('Username >')
    user_password = @prompt.mask('Password >')
    authenticate(username, user_password)
  end

  def authenticate(username, user_password)
    data_arr = load_data
    user_data(data_arr, username, user_password)
  end

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
