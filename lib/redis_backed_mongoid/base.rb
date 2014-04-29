require "redis_backed_mongoid/backer"
require "redis_backed_mongoid/reader"

module RedisBackedMongoid
  module Base
    def self.included(base)
      base.extend(ClassMethods)
      class << base
        attr_accessor :redis_backer_options
      end
    end

    def put_in_redis
      RedisBackedMongoid::Backer.new(self, self.class.redis_backer_options).write
    end

    def redis_backer_key
      @redis_backer_key ||= begin
        keys = self.class.redis_backer_options[:keys].map do |key|
          if key.is_a?(Proc)
            key.call(self).to_s
          else
            send(key).to_s
          end
        end
        RedisBackedMongoid.key(keys, self.class)
      end
    end

    def redis_backer_list_key
      @redis_backer_list_key ||= begin
        keys = self.class.redis_backer_options[:list_keys].map do |key|
          if key.is_a?(Proc)
            key.call(self).to_s
          else
            send(key).to_s
          end
        end
        keys << "list"
        RedisBackedMongoid.key(keys, self.class)
      end
    end

    module ClassMethods
      def redis_backed(options = {})
        defaults = {
          keys: [:id],
          list_keys: [],
          persistance_types: [:key],
          ttl: 30,
          class_name: self.to_s
        }

        self.redis_backer_options = defaults.merge(options)
        after_create(:put_in_redis)
      end

      def redis_getter(params={})
        RedisBackedMongoid::Reader.new(params, redis_backer_options)
      end
    end
  end
end
