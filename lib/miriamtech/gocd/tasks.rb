require 'pathname'
require 'rake/clean'

module MiriamTech
  module GoCD
    module DSL
      # rubocop:disable Style/HashSyntax, Style/SymbolArray, Metrics/MethodLength

      def define_gocd_tasks(
        image_name,
        revisions_to_keep: 10,
        build_args: {}
      )

        task :default => [:test]
        task :full => [:destroy_containers, :build]

        task :environment do
          ENV['BUILD_TAG'] = build_tag
        end

        CLEAN.add("#{root_path}/test/reports")
        task :stop_containers => [:environment]
        task :destroy_containers => [:environment, :clean, :cleanup_old_images]

        # These are here for compatibility
        task :clean => :stop_containers
        task :clobber => :destroy_containers

        if compose_file.exist?
          task :stop_containers => [:environment] do
            docker_compose 'stop'
          end

          task :destroy_containers => [:stop_containers] do
            docker_compose 'rm -fv'
          end
        end

        task :cleanup_old_images do
          cleanup_old_images(image_name, revisions_to_keep)
        end

        task :build => :environment do
          docker "build #{docker_build_arguments(build_args: build_args).join(' ')} -t #{image_name}#{build_tag} -t #{image_name}#{build_counter} #{root_path}"
        end

        task :test => [:environment, :destroy_containers] do
          at_exit { Rake::Task[:destroy_containers].execute }
        end

        task :save, [:path] => :environment do | t, args |
          args.with_defaults(path: File.join(root_path, '.docker', 'image.tar'))
          FileUtils.mkdir_p File.dirname(args[:path])
          docker "save #{image_name}#{build_tag} -o #{args[:path]}"
        end

        task :load, :path do | t, args |
          args.with_defaults(path: File.join(root_path, '.docker', 'image.tar'))
          docker "load -i #{args[:path]}"
        end

        task :push do
          push(image_name)
          push(image_name, 'latest')
        end

        task :deploy do
          pull(image_name)
          push(image_name, 'deployed')
        end

        task :bash do
          docker("run -it --rm #{image_name} bash")
        end
      end

      # rubocop:enable Style/HashSyntax, Style/SymbolArray, Metrics/MethodLength
    end
  end
end
