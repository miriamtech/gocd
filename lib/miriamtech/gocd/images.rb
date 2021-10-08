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
        images = `docker images --format '"{{.CreatedAt}}" id:{{.ID}}' #{image_name} | sort -r`.split("\n")
        images.each_with_index do |image, index|
          next if index >= number_to_keep
          match = image.match(/id:(.*)\z/)
          next unless match
          docker "image rm --force #{match[1]}"
        end
      end
    end
  end
end
