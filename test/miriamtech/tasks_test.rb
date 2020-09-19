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
    define_gocd_tasks('miriamtech/something')
    [:clean, :clobber, :build, :test, :push, :deploy].each do |task_name|
      assert rake_task(task_name), "Expected task :#{task_name} to be defined"
    end
  end

  def test_clean_includes_ruby_test_reports
    assert_empty CLEAN
    define_gocd_tasks('miriamtech/something')
    refute_empty CLEAN
    assert_includes(CLEAN, (root_path + 'test/reports').to_s)
  end

  def test_docker_compose_tasks_require_environment
    define_gocd_tasks('miriamtech/something')
    [:clean, :clobber, :build, :test,].each do |task_name|
      assert_includes rake_task(task_name).prerequisites, 'environment', "Task :#{task_name} needs :environment prereq"
    end
  end

  def test_test_requires_environment
    define_gocd_tasks('miriamtech/something')
    task = rake_task(:test)
    assert_includes task.prerequisites, 'environment'
  end

  def test_environment_exports_build_tag
    define_gocd_tasks('miriamtech/something')
    @build_tag = ':11235'
    assert_empty ENV['BUILD_TAG']
    begin
      Rake::Task[:environment].invoke
      assert_equal ':11235', ENV['BUILD_TAG']
    ensure
      ENV.delete('BUILD_TAG')
    end
  end

  private

  def rake_task(name)
    Rake::Task.tasks.detect { |each| each.name == name.to_s }
  end
end
