require "spec_helper"

describe "all your base" do
  it "saves the corect options on the class" do
    options = Dummy.redis_backer_options
    options.should_not be_nil
    options[:ttl].should == 30
  end

  it "calls the after_create method" do
    Dummy.should_receive(:after_create).with(:put_in_redis)
    Dummy.redis_backed
  end

  it "saves the item into redis" do
    Mongodis.redis.should_receive :setex
    Dummy.new.put_in_redis
  end
end