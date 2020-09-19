require 'pathname'
require 'rake/clean'

module MiriamTech
  module GoCD
    module DSL
      def define_gocd_tasks(
        image_name,
        revisions_to_keep: 10)

        task :default => [:test]
        task :full => [:clobber, :build]

        CLEAN.add(root_path + 'test/reports')
        task :clean do
          docker_compose "stop"
        end

        task :clobber => :cleanup_old_images do
          docker_compose "rm -fv"
        end

        task :cleanup_old_images do
          cleanup_old_images(image_name, revisions_to_keep)
        end

        task :build do
          docker "build --force-rm -t #{image_name}#{build_tag} #{root_path}"
        end

        task :test

        task :push do
          push(image_name)
          push(image_name, 'latest')
        end

        task :deploy do
          pull(image_name)
          push(image_name, 'deployed')
        end
      end
    end
  end
end
