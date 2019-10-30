module MiriamTech
  module GoCD
    module DSL
      def build_tag
        @build_tag || generate_build_tag
      end

      def pull(image_name)
        sh "docker pull #{image_name}#{build_tag}"
      end

      def push(image_name, tag = nil)
        if tag
          sh "docker tag #{image_name}#{build_tag} #{image_name}:#{tag}"
          sh "docker push #{image_name}:#{tag}"
        else
          sh "docker push #{image_name}#{build_tag}"
        end
      end

      def cleanup_old_images(image_name, number_to_keep)
        revision_number = ENV["GO_PIPELINE_COUNTER"].to_i
        return unless revision_number > number_to_keep
        images = `docker images --format "{{.Repository}}:{{.Tag}}" #{image_name}`.split(/\s+/)
        images.each do |image|
          next unless image.match(/:(\d+)\z/)
          if $1.to_i < revision_number - number_to_keep
            sh "docker image rm #{image}"
          end
        end
      end

      private

      def generate_build_tag
        if revision = ENV['GO_PIPELINE_COUNTER']
          @build_tag =":#{revision}"
        else
          @build_tag = ""
        end
        ENV['BUILD_TAG'] = @build_tag
      end
    end
  end
end
