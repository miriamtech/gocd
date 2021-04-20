require 'test_helper'

module MiriamTech
  module GoCD
    class ImagesTest < Minitest::Test
      include DSL

      def test_build_tag_empty_without_go_pipeline_counter
        assert_equal '', build_tag
      end

      def test_build_tag_based_on_go_pipeline_counter
        assert_equal ':11235', build_tag('GO_PIPELINE_COUNTER' => '11235')
      end

      def test_build_tag_cached
        @build_tag = ':whatever'
        assert_equal ':whatever', build_tag
      end
    end
  end
end
