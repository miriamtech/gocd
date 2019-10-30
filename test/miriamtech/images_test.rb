require "test_helper"

class MiriamTech::GoCD::ImagesTest < Minitest::Test
  include MiriamTech::GoCD::DSL

  def setup
    @saved_env = ENV.to_h
    @build_tag = nil # clear cache
  end

  def teardown
    restore_saved_env('GO_PIPELINE_COUNTER')
    restore_saved_env('BUILD_TAG')
    ENV.delete('GO_PIPELINE_COUNTER')
  end

  def test_build_tag_empty_without_go_pipeline_counter
    assert_equal '', build_tag
  end

  def test_build_tag_based_on_go_pipeline_counter
    ENV['GO_PIPELINE_COUNTER'] = '11235'
    assert_equal ':11235', build_tag
  end

  def test_build_tag_gets_exported_in_environment
    ENV['BUILD_TAG'] = nil
    ENV['GO_PIPELINE_COUNTER'] = '11235'
    assert_equal ':11235', build_tag
    assert_equal ':11235', ENV['BUILD_TAG']
  end

  def test_build_tag_cached
    @build_tag = ":whatever"
    assert_equal ":whatever", build_tag
    generate_build_tag
    refute_equal ":whatever", build_tag
  end

  private

  def restore_saved_env(key)
    if @saved_env.include?(key)
      ENV[key] = @saved_env[key]
    else
      ENV.delete(key)
    end
  end
end
