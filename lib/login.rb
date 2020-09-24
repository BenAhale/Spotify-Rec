module Login

  def userdata
    path = File.join(File.dirname(File.dirname(File.absolute_path(__FILE__))))
    userfile = "#{path}/users.json"
    return userfile
  end

  def clear
    system("clear")
  end

  def initial_login
    clear
    puts "---------------------------"
    puts "Welcome to the Spotify App!"
    puts "---------------------------"
    prompt = TTY::Prompt.new
    return prompt.select("Are you a new or returning user?", %w(New Returning))
  end

  def load_data
    file = File.read(userdata)
    return JSON.parse(file)
  end

  def gen_uid
    return load_data.length + 1
  end

  def store_user
    data = load_data
    user_details = {
      "id" => "#{$user.uid}",
      "username" => $user.username,
      "password" => $user.password,
      "playlist" => $user.playlist,
      "mylist" => $user.mylist
    }
    data << user_details
    File.open(userdata,"w") do |f|
      f.puts JSON.pretty_generate(data)
    end
    puts "You're now registered! Logging you in.."
    sleep(1)
    Menu::menu_router
  end

  def new_user
    system("clear")
    puts "Welcome! Please register for an account to continue."
    prompt = TTY::Prompt.new
    username = prompt.ask("Username >") { |u| u.validate(/\A[0-9a-zA-Z'-]*\z/, "Username must only contain letters and numbers")}
    password = prompt.mask("Password >")
    $user = User.new(username, password, gen_uid)
    store_user
  end

  def returning_user
    system("clear")
    puts "Welcome back! Please login to continue."
    prompt = TTY::Prompt.new
    username = prompt.ask("Username >")
    password= prompt.mask("Password >")
    authenticate(username, password)
  end

  def authenticate(username, password)
    data = load_data
    auth = false
    data.each do |hash|
      if hash["username"].downcase == username.downcase
        if hash["password"] == password
          auth = true
          $user = User.new(username, password, hash["id"], hash["playlist"], hash["mylist"])
          puts "Success! Logging you in.."
          sleep(1)
          Menu::menu_router
        end
      end
    end
    unless auth
      puts "Incorrect username or password!"
      sleep(1)
      returning_user
    end
  end

  def login
    new_returning = initial_login.downcase
    if new_returning == "new"
      new_user
    end
    if new_returning == "returning"
      returning_user
    end
  end

end