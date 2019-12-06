defmodule UtilsTest do
  use ExUnit.Case

  import BlockBox.Utils

  test "convert_text_opts" do
    opts1 = [label: "hello", block_id: "block_id"]
    opts2 = [label: %{text: "hello", type: :plain_text}, block_id: "block_id"]

    assert convert_text_opts(opts1, []) == opts1
    assert convert_text_opts(opts1, [:label]) == opts2
    assert convert_text_opts(opts2, [:label]) == opts2
  end

  test "convert_initial_opts no processing" do
    options = [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}]
    initial_option = %{text: "def", value: "hello"}
    opts = [options: options]
    assert convert_initial_opts(opts) === opts

    opts = [initial_option: initial_option, options: options]
    assert convert_initial_opts(opts) === opts
  end

  test "convert_initial_opts with processing" do
    options = [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}]
    option_groups = [%{label: "yo", options: options}]

    opts = [options: options, initial_option: 0]

    assert convert_initial_opts(opts) == [
             initial_option: %{text: "def", value: "hello"},
             options: options
           ]

    opts = [options: options, initial_options: [0, 1]]

    assert convert_initial_opts(opts) == [
             initial_options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}],
             options: options
           ]

    opts = [option_groups: option_groups, initial_option: {0, 1}]

    assert convert_initial_opts(opts) == [
             initial_option: %{text: "abc", value: "world"},
             option_groups: option_groups
           ]

    opts = [option_groups: option_groups, initial_options: [{0, 0}, {0, 1}]]

    assert convert_initial_opts(opts) == [
             initial_options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}],
             option_groups: option_groups
           ]
  end
end
