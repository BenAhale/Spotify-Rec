# frozen_string_literal: true

require_relative '../user'
require_relative '../login'
include Login
require 'json'

describe 'User' do
  it 'should create a user with a name, password and user id' do
    name = 'ben'
    password = 'password123'
    uid = '12345'
    user = User.new(name, password, uid)
    expect(user.username).to eq('ben')
    expect(user.password).to eq('password123')
    expect(user.uid).to eq('12345')
  end
end
