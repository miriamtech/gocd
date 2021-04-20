require 'test_helper'

module MiriamTech
  module GoCD
    class PathsTest < Minitest::Test
      include DSL
      include FileUtils

      def setup
        tmpdir = Dir.mktmpdir(self.class.name)
        @dir = Pathname.new(tmpdir)
      end

      def teardown
        rm_rf @dir
      end

      def test_root_path_dockerfile_in_cwd
        touch @dir / 'Dockerfile'
        cd @dir do
          assert_equal @dir, root_path
        end
      end

      def test_root_path_dockerfile_above_cwd
        touch @dir / 'Dockerfile'
        subdir = @dir / 'subdir'
        mkdir subdir
        cd subdir do
          assert_equal @dir, root_path
        end
      end

      def test_root_path_without_dockerfile_assumed_to_be_cwd
        cwd = Pathname.new(File.expand_path('.'))
        assert_equal cwd, root_path
        cd @dir do
          assert_equal @dir, root_path
        end
      end

      def test_compose_file
        cd @dir do
          refute compose_file.exist?
          File.open('docker-compose.yml', 'w') { |f| f.puts 'version: "3.8"' }
          assert compose_file.exist?
        end
      end
    end
  end
end
