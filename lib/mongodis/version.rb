module Mongodis
  VERSION = "0.0.1"

  class << self
    attr_accessor :redis

    def key(keys, klass)
      "mongodis:#{klass.to_s}:" + keys.join(":")
    end
  end
end
