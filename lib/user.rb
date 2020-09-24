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

end