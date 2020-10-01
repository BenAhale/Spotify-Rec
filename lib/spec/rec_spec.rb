require 'rspotify'
require_relative '../user'

RSpotify.authenticate('712ff89a218a4e6dbe1f169e06f949b9', 'e9e0517f405b4a01a1be8823126459b7')

describe 'Recommendations' do
  it 'should generate a list of recommendations' do
    genre = 'pop'
    recommendations = RSpotify::Recommendations.generate(limit: 5, seed_genres: [genre])
    expect(recommendations.tracks.length).to eq(5)
  end

  it 'should take the first recommendation and add it to the user playlist' do
    name = 'user'
    password = 'password123'
    uid = '12345'
    user = User.new(name, password, uid)
    genre = 'pop'
    recommendations = RSpotify::Recommendations.generate(limit: 5, seed_genres: [genre])
    track = recommendations.tracks.first
    user.playlist << track
    expect(user.playlist.length).to eq(1)
  end
end
