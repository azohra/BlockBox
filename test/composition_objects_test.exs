defmodule BlockBox.CompositionObectsTest do
  use ExUnit.Case
  alias BlockBox.CompositionObjects, as: CO

  test "text_object" do
    assert CO.text_object("hello") == %{text: "hello", type: :plain_text}
  end

  test "confirm_object" do
    assert CO.confirm_object("title", "prompt") == %{
             text: %{text: "prompt", type: :plain_text},
             confirm: %{text: "Confirm", type: :plain_text},
             deny: %{text: "Deny", type: :plain_text},
             title: %{text: "title", type: :plain_text}
           }
  end

  test "option_object" do
    assert CO.option_object("text", "value") == %{
             text: %{text: "text", type: :plain_text},
             value: "value"
           }
  end

  test "option_group_object" do
    options = [CO.option_object("text", "value")]

    assert CO.option_group_object("label", options) == %{
             label: %{text: "label", type: :plain_text},
             options: [%{text: %{text: "text", type: :plain_text}, value: "value"}]
           }
  end
end
