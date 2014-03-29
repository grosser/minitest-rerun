require "minitest/autorun"
require "minitest/spec"
$LOAD_PATH.unshift File.expand_path("../../../../lib", __FILE__)
require "minitest/rerun"

describe "foo" do
  describe "bar" do
    it "baz" do
      assert false
    end

    it "zap" do
      assert true
    end
  end
end
