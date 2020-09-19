module MiriamTech
  module GoCD
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

      def docker_compose(string)
        # PIPELINE_NAME = (ENV['GO_PIPELINE_NAME'] || 'ilien').downcase
        cd root_path do
          sh "docker-compose -p #{project_name} -f docker-compose.yml #{string}"
        end
      end

      private

      def generate_build_tag(env)
        if revision = env['GO_PIPELINE_COUNTER']
          @build_tag =":#{revision}"
        else
          @build_tag = ""
        end
        env['BUILD_TAG'] = @build_tag
      end
    end
  end
end
