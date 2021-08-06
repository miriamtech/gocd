require 'test_helper'
require 'fileutils'

module MiriamTech
  module GoCD
    class ArtifactsTest < Minitest::Test
      include DSL

      def test_with_artifacts_volume
        expect(self).to receive('random_hex').and_return('1234abcd')
        expect(self).to receive('docker').with('volume create foo_1234abcd')
        with_artifacts_volume 'foo' do |volume_name|
          expect(self).to receive('docker').with('volume rm foo_1234abcd')
          assert_equal 'foo_1234abcd', volume_name
        end
      end

      def test_artifacts_volume_name_strips_illegal_characters
        allow(self).to receive('docker')
        with_artifacts_volume('hello/world') do |volume_name|
          assert_match(/hello_world_.*/, volume_name)
        end
      end

      def test_capture_artifacts
        expect(self).to receive('random_hex').and_return('1234abcd')
        expect(self).to receive('docker').with('volume create foo_1234abcd')
        expect(self).to receive('copy_artifacts_from_volume')
        capture_artifacts('foo', workdir: '/path/to/app', path: 'test_results') do |volume_arg|
          expect(self).to receive('docker').with('volume rm foo_1234abcd')
          assert_equal '-v foo_1234abcd:/path/to/app/test_results', volume_arg
        end
      end

      def test_capture_artifacts_after_exception_raised
        expect(self).to receive('random_hex').and_return('1234abcd')
        expect(self).to receive('docker').with('volume create foo_1234abcd')
        expect(self).to receive('copy_artifacts_from_volume')
        assert_raises StandardError do
          capture_artifacts('foo', workdir: '/path/to/app', path: 'test_results') do |_volume_arg|
            expect(self).to receive('docker').with('volume rm foo_1234abcd')
            raise 'Something went wrong'
          end
        end
      end
    end
  end
end
