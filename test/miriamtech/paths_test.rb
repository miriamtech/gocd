require "test_helper"

class MiriamTech::GoCD::PathsTest < Minitest::Test
  include MiriamTech::GoCD::DSL
  include FileUtils

  def setup
    tmpdir = Dir::mktmpdir(self.class.name)
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
end
