require 'test_helper'

module MiriamTech
  module GoCD
    class LambdaTest < Minitest::Test
      include DSL

      def test_invoke_lambda
        expect(self).to receive('sh') do |arg|
          assert_match 'aws lambda invoke --function-name foo', arg
        end
        allow(self).to receive('puts') # Cheesy workaround for cheesy feedback mechanism
        invoke_lambda('foo')
      end
    end
  end
end
