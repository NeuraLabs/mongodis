require "json"
module RedisBackedMongoid
  class Reader
    def initialize(params, options)
      @options = options
      @params = params
    end

    def get
      raise "No simple get allowed" unless @options[:persistance_types].include?(:key)

      JSON.parse(RedisBackedMongoid.redis.get(redis_backer_key))
    end

    def get_all
      RedisBackedMongoid.redis.zrangebyscore(redis_backer_list_key, "-inf", "inf").map do |i|
        JSON.parse i
      end
    end

    private

    def redis_backer_key
      @redis_backer_key ||= begin
        keys = @options[:keys].map do |key|
          @params[key]
        end
        RedisBackedMongoid.key(keys, @options[:class_name])
      end
    end

    def redis_backer_list_key
      @redis_backer_list_key ||= begin
        keys = @options[:list_keys].map do |key|
          @params[key]
        end
        keys.push("list")
        RedisBackedMongoid.key(keys, @options[:class_name])
      end
    end
  end
end
