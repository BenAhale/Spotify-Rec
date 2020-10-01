# frozen_string_literal: true

require_relative '../user'
require 'json'
require 'tty-prompt'

describe 'User' do
  it 'should create a user with a name, password and user id' do
    name = 'user'
    password = 'password123'
    uid = '12345'
    user = User.new(name, password, uid)
    expect(user.username).to eq('user')
    expect(user.password).to eq('password123')
    expect(user.uid).to eq('12345')
  end

  it 'should create a user and add a track to the users MyList' do
    name = 'user'
    password = 'password123'
    uid = '12345'
    user = User.new(name, password, uid)
    song = {
      'name': 'Gyalchester',
      'artist': 'Drake',
      'id': '6UjfByV1lDLW0SOVQA4NAi',
      'type': 'track'
    }
    user.mylist << song
    expect(user.mylist.first[:name]).to eq('Gyalchester')
    expect(user.mylist.first[:artist]).to eq('Drake')
    expect(user.mylist.first[:id]).to eq('6UjfByV1lDLW0SOVQA4NAi')
  end
end
