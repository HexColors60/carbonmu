require_relative "../test_helper.rb"

class TestCommand < Command
  syntax "bar"
  syntax /foo/
end

class CommandTest < Minitest::Test
  def setup
    @context = mock("CommandContext")
    @context.stubs(:attributes).returns([])
  end

  def test_keeps_track_of_defined_syntaxes
    assert_equal TestCommand.syntaxes, ["bar", /foo/]
  end

  def test_stores_context
    command = Command.new(@context)

    assert_equal command.context, @context
  end

  def test_raises_if_execute_called_directly_on_command
    assert_raises(NotImplementedError) do
      Command.new(@context).execute
    end
  end

  def test_unpacks_the_context_into_instance_variables
    value = "FooBar"
    @context.stubs(:attributes).returns([:foo])
    @context.stubs(:foo).returns(value)

    t = TestCommand.new(@context)
    assert_equal t.instance_variable_get(:@foo), value
  end
end
