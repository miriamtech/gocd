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

      def build_counter(env = ENV)
        @build_counter ||= generate_build_counter(env)
      end

      def docker(string)
        sh "docker #{string}"
      end

      def docker_build_arguments(env = ENV, build_args: {})
        args = ['--force-rm']
        no_cache_arg = env['DOCKER_BUILD_NO_CACHE']
        args << '--no-cache' if no_cache_arg && !FALSY_ENV_VALUES.include?(no_cache_arg)
        build_args.each do |key, value|
          args << "--build-arg #{key}=#{value}"
        end
        args
      end

      def docker_compose(string)
        cd root_path do
          sh "docker-compose -p #{project_name} -f docker-compose.yml #{string}"
        end
      end

      private

      def generate_build_tag(env)
        revision = env['GO_REVISION_SOURCE']
        revision ? ":#{revision}" : ''
      end

      def generate_build_counter(env)
        counter = env['GO_PIPELINE_COUNTER']
        counter ? ":#{counter}" : ''
      end
    end
  end
end
