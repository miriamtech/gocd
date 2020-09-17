require "test_helper"
require "fileutils"

class MiriamTech::GoCD::DockerTest < Minitest::Test
  include MiriamTech::GoCD::DSL
  include FileUtils

  def test_project_name_default_is_cwd_tail
    assert_equal 'miriamtech-gocd', project_name
    cd '/tmp' do
      assert_equal 'tmp', project_name
    end
  end

  def test_project_name_from_go_pipeline_name
    assert_equal 'my-project', project_name('GO_PIPELINE_NAME' => 'my-project')
    assert_equal 'myproject', project_name('GO_PIPELINE_NAME' => 'MyProject')
  end
end
