require "spec_helper"
require "redis"

Mongodis.redis = Redis.new

describe Mongodis::Reader do
  before do
    Mongodis.redis.flushdb
  end

  describe "simple storage" do
    let(:dummy){Dummy.new}
    before do
      dummy.put_in_redis
      @reader = Dummy.redis_getter(id: "id")
    end

    it "reads the item" do
      @reader.get.should == {}
    end

    it "should read the item when to_json has info" do
      dummy.stub(:to_json).and_return('{"foo": "bar"}')
      dummy.put_in_redis
      @reader.get.should == {"foo" => "bar"}
    end
  end

  describe "lists" do
    before do
      @dummies = (1..4).map do |i|
        dummy = ListDummy.new
        dummy.stub(:id).and_return("id#{i}")
        dummy.put_in_redis
        dummy
      end
      @reader = ListDummy.redis_getter(name: "name")
    end

    it "should get number of objects" do
      @reader.get_all.map{|i| i["id"]}.should == ["id1", "id2", "id3", "id4"]
    end

    it "should get only the objects it needs" do
      another_dummy = ListDummy.new
      another_dummy.stub(:id).and_return("id6")
      another_dummy.stub(:name).and_return("name2")
      another_dummy.put_in_redis
      @reader.get_all.map{|i| i["id"]}.should == ["id1", "id2", "id3", "id4"]
      ListDummy.redis_getter(name: "name2").get_all.first["id"].should == "id6"
    end

  end
end
