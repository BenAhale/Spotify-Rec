require_relative 'menu'

module Login
  
  @prompt = prompt = TTY::Prompt.new

  def user
    @user
  end

  def userdata
    path = File.join(File.dirname(File.dirname(File.absolute_path(__FILE__))))
    userfile = "#{path}/public/users.json"
    userfile
  end

  def clear
    system('clear')
  end

  def initial_login
    clear
    puts "               ;;;;;;;;;;;;;;;;;;;
               ;;;;;;;;;;;;;;;;;;;
               ;                 ;
               ;                 ;
               ;                 ;
               ;                 ;
               ;                 ;
               ;                 ;
           ,;;;;;            ,;;;;;
           ;;;;;;            ;;;;;;
           `;;;;'            `;;;;'
           ".colorize(:light_green)
    puts '》  Welcome to the Spotify Recommendations App!  《'.colorize(:light_green)
    puts
    @prompt.select("Are you a new or returning user? \n", %w[New Returning])
  end

  def load_data
    file = File.read(userdata)
    JSON.parse(file)
  end

  def gen_uid
    load_data.length + 1
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
    File.open(userdata, 'w') do |f|
      f.puts JSON.pretty_generate(data)
    end
    puts "You're now registered! Logging you in..".colorize(:light_green)
    sleep(1)
    @menu = Menu.new(@user)
    @menu.menu_router
  end

  def new_user
    system('clear')
    puts 'Welcome! Please register for an account to continue.'.colorize(:light_green)
    username = @prompt.ask('Username >') { |u| u.validate(/\A[0-9a-zA-Z'-]*\z/, 'Username must only contain letters and numbers') }
    password = @prompt.mask('Password >')
    @user = User.new(username, password, gen_uid)
    @user_playlist = Playlist.new(@user)
    store_user
  end

  def returning_user
    system('clear')
    puts 'Welcome back! Please login to continue.'.colorize(:light_green)
    username = @prompt.ask('Username >')
    password = @prompt.mask('Password >')
    authenticate(username, password)
  end

  def authenticate(username, password)
    data = load_data
    auth = false
    data.each do |hash|
      next unless hash['username'].downcase == username.downcase

      next unless hash['password'] == password

      auth = true
      @user = User.new(username, password, hash['id'], hash['playlist'], hash['mylist'])
      @user_playlist = Playlist.new(@user)
      puts 'Success! Logging you in..'.colorize(:light_green)
      sleep(1)
      @menu = Menu.new(@user)
      @menu.menu_router
    end
    unless auth
      puts 'Incorrect username or password!'.colorize(:red)
      sleep(1)
      returning_user
    end
  end

  def login
    new_returning = initial_login.downcase
    new_user if new_returning == 'new'
    returning_user if new_returning == 'returning'
  end
end
