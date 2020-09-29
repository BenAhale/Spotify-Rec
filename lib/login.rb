# frozen_string_literal: true

require_relative 'menu'

module Login
  @prompt = TTY::Prompt.new

  def user
    @user
  end

  def userdata
    path = File.join(File.dirname(File.dirname(File.absolute_path(__FILE__))))
    "#{path}/public/users.json"
  end

  def clear
    system('clear')
  end

  def initial_login
    clear
    ascii_art
    puts '》  Welcome to the Spotify Recommendations App!  《'.colorize(:light_green)
    puts
    @prompt.select("Are you a new or returning user? \n", %w[New Returning])
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

  def load_data
    file = File.read(userdata)
    JSON.parse(file)
  end

  def gen_uid
    load_data.length + 1
  end

  def go_to_menu
    menu = Menu.new(@user)
    menu.menu_router
  end

  def write_user(data)
    File.open(userdata, 'w') do |f|
      f.puts JSON.pretty_generate(data)
    end
    puts "You're now registered! Logging you in..".colorize(:light_green)
    sleep(1)
    go_to_menu
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

  def new_user
    system('clear')
    puts 'Welcome! Please register for an account to continue.'.colorize(:light_green)
    username = @prompt.ask('Username >')
    password = @prompt.mask('Password >')
    @user = User.new(username, password, gen_uid)
    @user_playlist = Playlist.new(@user)
    store_user
  end

  def returning_user
    system('clear')
    puts 'Welcome back! Please login to continue.'.colorize(:light_green)
    username = @prompt.ask('Username >')
    user_password = @prompt.mask('Password >')
    puts "we get here! 1"
    authenticate(username, user_password)
  end

  def data_array(data, username, user_password)
    data.each do |hash|
      puts "Do we get here? #{hash}"
      next unless hash['username'].downcase == username.downcase

      next unless hash['password'] == user_password

      @user = User.new(username, user_password, hash['id'], hash['playlist'], hash['mylist'])
      go_to_menu
    end
    no_auth
  end

  def no_auth
    puts 'Incorrect username or password!'.colorize(:red)
    returning_user
  end

  def authenticate(username, user_password)
    puts "We get here 2"
    data_arr = load_data
    puts "We get here 3"
    data_array(data_arr, username, user_password)
  end

  def login
    new_returning = initial_login.downcase
    new_user if new_returning == 'new'
    returning_user if new_returning == 'returning'
  end
end
