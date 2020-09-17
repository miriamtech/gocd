require "test_helper"
require "rake"

class MiriamTech::GoCD::ArtifactsTest < Minitest::Test
  include MiriamTech::GoCD::DSL
  include Rake::DSL

  def test_define_gocd_tasks
    refute rake_task(:build)
    define_gocd_tasks('miriamtech/something')
    assert rake_task(:build)
  end

  private

  def rake_task(name)
    Rake::Task.tasks.detect { |each| each.name == name.to_s }
  end
end
