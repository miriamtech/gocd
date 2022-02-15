require 'test_helper'
require 'rake'

module MiriamTech
  module GoCD
    class TasksTest < Minitest::Test
      include DSL
      include Rake::DSL

      def teardown
        Rake::Task.clear
        CLEAN.clear
      end

      def test_define_gocd_tasks
        define_gocd_tasks('miriamtech/something')
        %i[clean stop_containers destroy_containers build test push deploy save load].each do |task_name|
          assert rake_task(task_name), "Expected task :#{task_name} to be defined"
        end
      end

      def test_clean_includes_ruby_test_reports
        assert_empty CLEAN
        define_gocd_tasks('miriamtech/something')
        refute_empty CLEAN
        assert_includes(CLEAN, "#{root_path}/test/reports")
      end

      def test_docker_compose_tasks_require_environment
        define_gocd_tasks('miriamtech/something')
        %i[stop_containers destroy_containers build test save].each do |task_name|
          assert_includes rake_task(task_name).prerequisites,
                          'environment',
                          "Task :#{task_name} needs :environment prereq"
        end
      end

      def test_environment_exports_build_tag
        define_gocd_tasks('miriamtech/something')
        @build_tag = ':11235'
        assert_empty(ENV['BUILD_TAG'] || '')
        begin
          Rake::Task[:environment].invoke
          assert_equal ':11235', ENV['BUILD_TAG']
        ensure
          ENV.delete('BUILD_TAG')
        end
      end

      def test_build_task_tags_with_tag_and_counter
        RSpec::Matchers.define :tag_matcher do
          match do |actual|
            actual.include?('-t miriamtech/something:123') && actual.include?('-t miriamtech/something:abcd1234')
          end
        end

        allow(self).to receive(:build_tag).and_return(':abcd1234')
        allow(self).to receive(:build_counter).and_return(':123')
        expect(self).to receive(:docker).with(tag_matcher)

        define_gocd_tasks('miriamtech/something')
        begin
          Rake::Task[:build].invoke
        ensure
          ENV.delete('BUILD_TAG')
        end
      end

      private

      def rake_task(name)
        Rake::Task.tasks.detect { |each| each.name == name.to_s }
      end
    end
  end
end
