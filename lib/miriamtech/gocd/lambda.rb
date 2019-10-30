module MiriamTech
  module GoCD
    module DSL
      def invoke_lambda(lambda)
        Tempfile.open(lambda) do |temp|
          sh "aws lambda invoke --function-name #{lambda} #{temp.path}"
          puts temp.read
        end
      end
    end
  end
end
