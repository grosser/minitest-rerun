require "minitest/autorun"
$LOAD_PATH.unshift File.expand_path("../../../../lib", __FILE__)
require "minitest/rerun"

class Test < Minitest::Test
  i_suck_and_my_tests_are_order_dependent!

  def test_xxx
    assert false
  end

  def test_zzz
    raise
  end

  def test_yyy
    assert true
  end
end
