module RedisBackedMongoid
  class Backer
    def initialize(mongoid_object, options)
      @options = options
      @mongoid_object = mongoid_object
    end

    def write
      key = @mongoid_object.redis_backer_key

      if @options[:persistance_types].include?(:key)
        RedisBackedMongoid.redis.setex(key, @mongoid_object.to_json, @options[:ttl])
      end

      if @options[:persistance_types].include?(:sorted_set)
        RedisBackedMongoid.redis.zadd(key+":sorted_set", @mongoid_object.created_at.to_i, @mongoid_object.to_json)
        RedisBackedMongoid.redis.zremrangebyrank(key+":sorted_set", 0, @mongoid_object.created_at.to_i - @options[:ttl])
      end
    end
  end
end
