require "minitest/autorun"
$LOAD_PATH.unshift File.expand_path("../../../../lib", __FILE__)
require "minitest/rerun"

class Test < MiniTest::Unit::TestCase
  def test_xxx
    assert false
  end

  def test_yyy
    assert true
  end
end
