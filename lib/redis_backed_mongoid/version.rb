module RedisBackedMongoid
  VERSION = "0.0.1"

  class << self
    attr_accessor :redis

    def key(keys, klass)
      "redis_backed_mongoid:#{klass.to_s}:" + keys.join(":")
    end
  end
end
