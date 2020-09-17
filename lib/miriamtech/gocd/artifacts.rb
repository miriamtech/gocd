module MiriamTech
  module GoCD
    module DSL
      def with_artifacts_volume(prefix = project_name, &block)
        artifacts_volume = "#{prefix}#{build_tag}".gsub('[/:]', '_')
        docker "volume create #{artifacts_volume}"
        yield artifacts_volume
      ensure
        docker "volume rm #{artifacts_volume}"
      end

      def copy_artifacts_from_volume(volume, local_path:)
        container_id = `docker create -v #{volume}:/artifacts_volume #{WORKER_IMAGE} cp -a /artifacts_volume /artifacts_tmp`.chomp
        begin
          docker "start -i #{container_id}"
          cd root_path do
            sh "docker cp #{container_id}:/artifacts_tmp/. #{local_path}"
          end
        ensure
          docker "rm -v #{container_id}"
        end
      end
    end
  end
end
