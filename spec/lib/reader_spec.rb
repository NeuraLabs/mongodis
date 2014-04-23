require "spec_helper"

RedisBackedMongoid.redis = Redis.new

describe RedisBackedMongoid::Reader do
  let(:dummy){Dummy.new}
  before do
    dummy.put_in_redis
  end

  it "reads the item" do
    Dummy.redis_getter(id: "id").should == {}
  end
end
