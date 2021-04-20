module MiriamTech
  module GoCD
    FALSY_ENV_VALUES = (%w[0 f false n no] + ['']).freeze
    module DSL
      def project_name(env = ENV)
        (env['GO_PIPELINE_NAME'] || root_path.basename.to_s).downcase
      end

      def build_tag(env = ENV)
        @build_tag ||= generate_build_tag(env)
      end

      def docker(string)
        sh "docker #{string}"
      end

      def docker_build_arguments(env = ENV)
        args = ['--force-rm']
        no_cache_arg = env['DOCKER_BUILD_NO_CACHE']
        args << '--no-cache' if no_cache_arg && !FALSY_ENV_VALUES.include?(no_cache_arg)
        args
      end

      def docker_compose(string)
        cd root_path do
          sh "docker-compose -p #{project_name} -f docker-compose.yml #{string}"
        end
      end

      private

      def generate_build_tag(env)
        revision = env['GO_PIPELINE_COUNTER']
        if revision
          @build_tag = revision ? ":#{revision}" : ''
        else
          @build_tag = ''
          ''
        end
      end
    end
  end
end
