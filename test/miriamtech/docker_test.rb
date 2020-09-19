require "test_helper"
require "fileutils"

class MiriamTech::GoCD::DockerTest < Minitest::Test
  include MiriamTech::GoCD::DSL
  include FileUtils

  def test_project_name_default_is_root_path_tail
    assert_equal 'miriamtech-gocd', project_name
    expect(self).to receive('root_path').and_return(Pathname.new('/path/to/wherever'))
    assert_equal 'wherever', project_name
  end

  def test_project_name_from_go_pipeline_name
    assert_equal 'my-project', project_name('GO_PIPELINE_NAME' => 'my-project')
    assert_equal 'myproject', project_name('GO_PIPELINE_NAME' => 'MyProject')
  end
end
