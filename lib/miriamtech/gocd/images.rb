module MiriamTech
  module GoCD
    module DSL
      WORKER_IMAGE = 'debian:buster'.freeze

      def pull(image_name)
        docker "pull #{image_name}#{build_tag}"
      end

      def push(image_name, tag = nil)
        if tag
          docker "tag #{image_name}#{build_tag} #{image_name}:#{tag}"
          docker "push #{image_name}:#{tag}"
        else
          docker "push #{image_name}#{build_tag}"
        end
      end

      def cleanup_old_images(image_name, number_to_keep)
        revision_number = ENV['GO_PIPELINE_COUNTER'].to_i
        return unless revision_number > number_to_keep
        images = `docker images --format "{{.Repository}}:{{.Tag}}" #{image_name}`.split(/\s+/)
        images.each do |image|
          next unless image.match(/:(\d+)\z/)
          next unless Regexp.last_match(1).to_i < revision_number - number_to_keep
          docker "image rm #{image}"
        end
      end
    end
  end
end
