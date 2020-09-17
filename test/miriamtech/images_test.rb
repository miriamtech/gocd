require "test_helper"

class MiriamTech::GoCD::ImagesTest < Minitest::Test
  include MiriamTech::GoCD::DSL

  def test_build_tag_empty_without_go_pipeline_counter
    assert_equal '', build_tag
  end

  def test_build_tag_based_on_go_pipeline_counter
    assert_equal ':11235', build_tag('GO_PIPELINE_COUNTER' => '11235')
  end

  def test_build_tag_gets_exported_in_environment
    env = { 'GO_PIPELINE_COUNTER' => '11235' }
    assert_equal ':11235', build_tag(env)
    assert_equal ':11235', env['BUILD_TAG']
  end

  def test_build_tag_cached
    @build_tag = ":whatever"
    assert_equal ":whatever", build_tag
  end
end
