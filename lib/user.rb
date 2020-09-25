class User

  attr_reader :username, :password, :uid
  attr_accessor :playlist, :mylist

  def initialize(username, password, uid, playlist=[], mylist=[])
    @username = username
    @password = password
    @playlist = playlist
    @uid = uid
    @mylist = mylist
  end

  def details
    puts "Username: #{@username}"
    puts "Password: #{@password}"
    puts "User ID: #{@uid}"
    $prompt.keypress("Press any key to continue..")
    Menu::account_details
  end

  def change_username(new_name)
    updated_data = Login.load_data.each { |user| user["username"] = new_name if user["id"] == $user.uid.to_s }
    File.open((Login::userdata),"w") do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
    @username = new_name
    puts "Success! Your new username is #{$user.username}"
    $prompt.keypress("Press any key to continue..")
    Menu::account_details
  end

  def change_password(new_password)
    updated_data = Login.load_data.each { |user| user["password"] = new_password if user["id"] == $user.uid.to_s }
    File.open((Login::userdata),"w") do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
    @password = new_password
    puts "Success! Your password has been changed."
    $prompt.keypress("Press any key to continue..")
    Menu::account_details
  end

  def delete_from_file
    updated_data = []
    Login.load_data.each { |user| updated_data << user unless user["id"] == $user.uid.to_s }
    File.open((Login::userdata),"w") do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
    puts "Your account has been deleted. The program will now exit."
    $prompt.keypress("Press any key to continue..")
    exit
  end
  

  def delete_account
    prompt = TTY::Prompt.new
    puts "Woah there! Deleting your account is serious business, and cannot be undone."
    selection = prompt.yes?("Are you sure you want to delete your account?")
    unless selection
      Menu::menu_router
    else
      delete_from_file
    end
  end

end