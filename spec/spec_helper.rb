require "rspec"

require 'redis_backed_mongoid/base'
class Dummy
  include RedisBackedMongoid::Base
  def self.after_create(foo); end

  def id
    "id"
  end

  def created_at
    Time.now
  end

  def to_json
    "{}"
  end

  redis_backed
end

class ListDummy
  include RedisBackedMongoid::Base
  def self.after_create(foo); end

  def id
    "id"
  end

  def name
    "name"
  end

  def created_at
    Time.now
  end

  def to_json
    %{{"name": "#{name}", "id": "#{id}"}}
  end

  redis_backed persistance_types: [:key, :list], keys: [:id, :name], list_keys: [:name]
end
