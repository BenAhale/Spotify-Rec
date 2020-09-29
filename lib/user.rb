# frozen_string_literal: true

# An instance of User should be made for everyone who logs in or signs up
class User
  attr_reader :username, :password, :uid
  attr_accessor :playlist, :mylist

  def initialize(username, password, uid, playlist = [], mylist = [])
    @username = username
    @password = password
    @playlist = playlist
    @uid = uid
    @mylist = mylist
    @prompt = TTY::Prompt.new
  end

  def details
    puts "Username: #{@username.colorize(:light_green)}"
    puts "Password: #{@password.colorize(:light_green)}"
    puts "User ID: #{@uid.to_s.colorize(:light_green)}"
    @prompt.keypress('Press any key to continue..')
    menu = Menu.new(Login.user)
    menu.account_details
  end

  def update_username(new_name)
    updated_data = Login.load_data.each do |user|
      user['username'] = new_name if user['id'] == Login.user.uid.to_s
    end
    File.open(Login.userdata, 'w') do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
  end

  def change_username(new_name)
    update_username(new_name)
    @username = new_name
    puts "Success! Your new username is #{Login.user.username}".colorize(:light_green)
    @prompt.keypress('Press any key to continue..')
    menu = Menu.new(Login.user)
    menu.account_details
  end

  def update_password(new_password)
    updated_data = Login.load_data.each do |user|
      user['password'] = new_password if user['id'] == Login.user.uid.to_s
    end
    File.open(Login.userdata, 'w') do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
  end

  def change_password(new_password)
    update_password(new_password)
    @password = new_password
    puts 'Success! Your password has been changed.'.colorize(:light_green)
    @prompt.keypress('Press any key to continue..')
    menu = Menu.new(Login.user)
    menu.account_details
  end

  def delete_from_file
    updated_data = []
    Login.load_data.each { |user| updated_data << user unless user['id'] == Login.user.uid.to_s }
    File.open(Login.userdata, 'w') do |f|
      f.puts JSON.pretty_generate(updated_data)
    end
    puts 'Your account has been deleted. The program will now exit.'.colorize(:light_red)
    @prompt.keypress('Press any key to continue..')
    exit
  end

  def delete_account
    puts 'Woah there! Deleting your account is serious business, and cannot be undone.'.colorize(:light_red)
    selection = @prompt.yes?('Are you sure you want to delete your account?'.colorize(:light_red))
    if selection
      delete_from_file
    else
      menu = Menu.new(Login.user)
      menu.account_details
    end
  end
end
