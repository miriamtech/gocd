module MiriamTech
  module GoCD
    module DSL
      def capture_artifacts(prefix = project_name, workdir:, path:)
        with_artifacts_volume(prefix) do |volume_name|
            yield "-v #{volume_name}:#{workdir}/#{path}"
        ensure
          copy_artifacts_from_volume(volume_name, local_path: path)
        end
      end

      def with_artifacts_volume(prefix = project_name)
        artifacts_volume = sanitized_volume_name("#{prefix}#{build_tag}")
        docker "volume create #{artifacts_volume}"
        yield artifacts_volume
      ensure
        docker "volume rm #{artifacts_volume}"
      end

      def copy_artifacts_from_volume(volume, local_path:)
        container_id = `docker create -v #{volume}:/artifacts #{WORKER_IMAGE} cp -a /artifacts /artifacts_tmp`.chomp
        begin
          docker "start -i #{container_id}"
          cd root_path do
            sh "docker cp #{container_id}:/artifacts_tmp/. #{local_path}"
          end
        ensure
          docker "rm -v #{container_id}"
        end
      end

      private

      def sanitized_volume_name(name)
        name.gsub(/[^-_.A-Za-z0-9]/, '_')
      end
    end
  end
end
