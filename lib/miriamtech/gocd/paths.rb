require 'pathname'

module MiriamTech
  module GoCD
    module DSL
      def root_path
        cwd = Pathname.new(File.expand_path('.'))
        path = Pathname.new(cwd)
        begin
          return path if path.join('Dockerfile').exist?
          path = path.parent
        end until path.root?
        cwd
      end

      def compose_file
        root_path / 'docker-compose.yml'
      end
    end
  end
end
