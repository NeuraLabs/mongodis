module Mongodis
  class Backer
    def initialize(mongoid_object, options)
      @options = options
      @mongoid_object = mongoid_object
    end

    def write
      if @options[:persistance_types].include?(:key)
        key = @mongoid_object.redis_backer_key
        Mongodis.redis.setex(key, @options[:ttl], @mongoid_object.to_json)
      end

      if @options[:persistance_types].include?(:list)
        key = @mongoid_object.redis_backer_list_key
        Mongodis.redis.zadd(key, @mongoid_object.created_at.to_i, @mongoid_object.to_json)
        #Mongodis.redis.zremrangebyrank(key, 0, @mongoid_object.created_at.to_i - @options[:ttl])
      end
    end
  end
end
