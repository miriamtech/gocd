require 'test_helper'
require 'fileutils'

module MiriamTech
  module GoCD
    class DockerTest < Minitest::Test
      include DSL
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

      def test_project_name_from_pipeline_and_stage
        env = {
          'GO_PIPELINE_NAME' => 'my-project',
          'GO_STAGE_NAME' => 'my-stage',
        }
        assert_equal 'my-project-my-stage', project_name(env)
      end

      def test_project_name_from_pipeline_and_stage
        env = {
          'GO_PIPELINE_NAME' => 'my-project',
          'GO_JOB_NAME' => 'my-job',
        }
        assert_equal 'my-project-my-job', project_name(env)
      end

      def test_project_name_from_pipeline_stage_and_job
        env = {
          'GO_PIPELINE_NAME' => 'my-project',
          'GO_STAGE_NAME' => 'my-stage',
          'GO_JOB_NAME' => 'my-job',
        }
        assert_equal 'my-project-my-stage-my-job', project_name(env)
      end

      def test_docker_build_arguments
        assert_includes docker_build_arguments, '--force-rm'
      end

      def test_docker_build_arguments_dict
        assert_includes docker_build_arguments(build_args: { foo: 'bar' }), '--build-arg foo=bar'
      end

      def test_docker_build_no_cache
        refute_includes docker_build_arguments, '--no-cache'
        (%w[0 f false n no] + ['']).each do |falsy|
          refute_includes(
            docker_build_arguments({ 'DOCKER_BUILD_NO_CACHE' => falsy }),
            '--no-cache',
            "DOCKER_BUILD_NO_CACHE=#{falsy.inspect} should not add '--no-cache' arg",
          )
        end
        %w[1 t true y yes definitely].each do |truthy|
          assert_includes(
            docker_build_arguments({ 'DOCKER_BUILD_NO_CACHE' => truthy }),
            '--no-cache',
            "DOCKER_BUILD_NO_CACHE=#{truthy.inspect} should add '--no-cache' arg",
          )
        end
      end
    end
  end
end
