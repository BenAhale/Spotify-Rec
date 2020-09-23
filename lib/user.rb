class User

  attr_reader :username, :password, :uid
  attr_accessor :playlist, :topten

  def initialize(username, password, uid, playlist=[], topten=[])
    @username = username
    @password = password
    @playlist = playlist
    @uid = uid
    @topten = topten
  end

end