require 'test_helper'
require 'fileutils'

module MiriamTech
  module GoCD
    class ArtifactsTest < Minitest::Test
      include DSL

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

      def test_capture_artifacts
        expect(self).to receive('docker').with('volume create foo')
        expect(self).to receive('copy_artifacts_from_volume')
        capture_artifacts('foo', workdir: '/path/to/app', path: 'test_results') do |volume_arg|
          expect(self).to receive('docker').with('volume rm foo')
          assert_equal '-v foo:/path/to/app/test_results', volume_arg
        end
      end

      def test_capture_artifacts_after_exception_raised
        expect(self).to receive('docker').with('volume create foo')
        expect(self).to receive('copy_artifacts_from_volume')
        assert_raises StandardError do
          capture_artifacts('foo', workdir: '/path/to/app', path: 'test_results') do |_volume_arg|
            expect(self).to receive('docker').with('volume rm foo')
            raise 'Something went wrong'
          end
        end
      end
    end
  end
end
