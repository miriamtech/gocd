require 'test_helper'

module MiriamTech
  module GoCD
    class GoCDTest < Minitest::Test
      def test_that_it_has_a_version_number
        refute_nil ::MiriamTech::GoCD::VERSION
      end
    end
  end
end
