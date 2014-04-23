module RedisBackedMongoid
  VERSION = "0.0.1"

  class << self
    attr_accessor :redis
  end
end
