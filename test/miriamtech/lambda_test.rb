require "test_helper"

class MiriamTech::GoCD::LambdaTest < Minitest::Test
  include MiriamTech::GoCD::DSL

  def test_invoke_lambda
    expect(self).to receive('sh') do |arg|
      assert_match 'aws lambda invoke --function-name foo', arg
    end
    allow(self).to receive('puts') # Cheesy workaround for cheesy feedback mechanism
    invoke_lambda('foo')
  end
end
