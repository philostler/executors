require "spec/spec_helper"

describe Executors::Cache do
  [:[], :get].each do |method|
    describe "." + method.to_s do
      it "should return the executor instance against the given id"

      describe "(id)" do
        it "should raise an exception when given a nil"
        it "should raise an exception when not given a string or symbol"
        context "when there is no executor instance against the given value" do
          it "should return nil"
        end
      end
    end
  end

  [:[]=, :add].each do |method|
    describe "." + method.to_s do
      it "should add the given executor instance against the given id"
      it "should return the given id as a symbol"

      describe "(id)" do
        it "should raise an exception when given a nil"
        it "should raise an exception when not given a string or symbol"
        context "when invoked twice with the same value" do
          it "should not raise an exception"
          it "should replace the current executor instance with given executor instance"
        end
      end
      describe "(executor)" do
        it "should raise an exception when given a nil"
        it "should raise an exception when not given an executor instance"
        context "when invoked twice with the same instance" do
          it "should raise an exception"
        end
      end
    end
  end

  describe ".remove" do
    it "should remove the executor instance against the given id"
    it "should return the executor instance against the given id"

    describe "(id)" do
      it "should raise an exception when given a nil"
      it "should raise an exception when not given a string or symbol"
      context "when there is no executor instance against the given value" do
        it "should return nil"
      end
    end
  end

  describe ".shutdown" do
  end

  describe ".shutdown!" do
  end

  describe ".size" do
    it "should initially be zero"

    context "when executor instance is added" do
      it "should increment by one"
    end
    context "when executor instance is removed" do
      it "should decrement by one"
    end
  end
end