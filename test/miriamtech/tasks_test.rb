require "test_helper"
require "rake"

class MiriamTech::GoCD::TasksTest < Minitest::Test
  include MiriamTech::GoCD::DSL
  include Rake::DSL

  def teardown
    Rake::Task.clear
    CLEAN.clear
  end

  def test_define_gocd_tasks
    refute rake_task(:build)
    define_gocd_tasks('miriamtech/something')
    assert rake_task(:build)
  end

  def test_clean_includes_ruby_test_reports
    assert_empty CLEAN
    define_gocd_tasks('miriamtech/something')
    refute_empty CLEAN
    assert_includes(CLEAN, (root_path + 'test/reports').to_s)
  end

  private

  def rake_task(name)
    Rake::Task.tasks.detect { |each| each.name == name.to_s }
  end
end
