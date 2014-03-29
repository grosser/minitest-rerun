require "minitest/autorun"
require_relative "some_lib"
$LOAD_PATH.unshift File.expand_path("../../../../lib", __FILE__)
require "minitest/rerun"

class SimpleTest < MiniTest::Unit::TestCase
  extend SomeLib

  do_it

  def test_yyy
    assert true
  end
end
