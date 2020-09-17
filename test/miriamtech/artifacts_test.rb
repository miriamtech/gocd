require "test_helper"
require "fileutils"

class MiriamTech::GoCD::ArtifactsTest < Minitest::Test
  include MiriamTech::GoCD::DSL

  def test_with_artifacts_volume
    expect(self).to receive('docker').with('volume create foo')
    with_artifacts_volume 'foo' do |volume_name|
      expect(self).to receive('docker').with('volume rm foo')
      assert_equal 'foo', volume_name
    end
  end

  def test_artifacts_volume_name_strips_illegal_characters
    allow(self).to receive('docker')
    @build_tag = ':123'
    with_artifacts_volume('hello/world') do |volume_name|
      assert_equal 'hello_world_123', volume_name
    end
  end
end
