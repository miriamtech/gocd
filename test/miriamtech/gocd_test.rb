require "test_helper"

class MiriamTech::GoCDTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::MiriamTech::GoCD::VERSION
  end
end
