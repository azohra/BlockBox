defmodule BlockBox.BlockElementsTest do
  use ExUnit.Case
  alias BlockBox.BlockElements, as: BE
  alias BlockBox.Utils, as: Utils

  test "button" do
    assert BE.button("text", "id") == %{
             type: "button",
             action_id: "id",
             text: %{text: "text", type: :plain_text}
           }

    assert BE.button("text", "id", value: "value") == %{
             action_id: "id",
             text: %{text: "text", type: :plain_text},
             type: "button",
             value: "value"
           }
  end

  test "datepicker" do
    assert BE.datepicker("id") == %{action_id: "id", type: "datepicker"}

    assert BE.datepicker("id", placeholder: "select date") == %{
             action_id: "id",
             type: "datepicker",
             placeholder: %{text: "select date", type: :plain_text}
           }

    assert BE.datepicker("id", initial_date: "initial_date") == %{
             action_id: "id",
             type: "datepicker",
             initial_date: "initial_date"
           }

    today = Utils.today()

    assert BE.datepicker("id", initial_date: "today") == %{
             action_id: "id",
             type: "datepicker",
             initial_date: today
           }
  end

  test "image" do
    assert BE.image("url", "alt_text") == %{alt_text: "alt_text", image_url: "url", type: "image"}
  end

  test "overflow_menu" do
    assert BE.overflow_menu("id", []) == %{action_id: "id", options: [], type: "overflow"}
  end

  test "plain_text_input" do
    assert BE.plain_text_input("id") == %{action_id: "id", type: "plain_text_input"}

    assert BE.plain_text_input("id", placeholder: "ph") == %{
             action_id: "id",
             type: "plain_text_input",
             placeholder: %{text: "ph", type: :plain_text}
           }
  end

  test "radio_buttons" do
    assert BE.radio_buttons("id", []) == %{action_id: "id", options: [], type: "radio_buttons"}
    assert BE.radio_buttons("id", [%{text: "def", value: "hello"}], initial_option: 0) == %{action_id: "id", options: [%{text: "def", value: "hello"}], initial_option: %{text: "def", value: "hello"}, type: "radio_buttons"}
  end

  test "select_menu" do
    assert BE.select_menu("placeholder", :static_select, "id") == %{
             action_id: "id",
             placeholder: %{text: "placeholder", type: :plain_text},
             type: :static_select
           }

    assert BE.select_menu("placeholder", :static_select, "id", options: []) == %{
             action_id: "id",
             placeholder: %{text: "placeholder", type: :plain_text},
             type: :static_select,
             options: []
           }
    
    assert BE.select_menu("placeholder", :static_select, "id", options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}], initial_option: 0) == %{
             action_id: "id",
             placeholder: %{text: "placeholder", type: :plain_text},
             type: :static_select,
             options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}],
             initial_option: %{text: "def", value: "hello"}
           }
    
    assert BE.select_menu("placeholder", :static_select, "id", option_groups: [%{label: "yo", options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}]}], initial_option: {0,1}) == %{
             action_id: "id",
             placeholder: %{text: "placeholder", type: :plain_text},
             type: :static_select,
             option_groups: [%{label: "yo", options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}]}],
             initial_option: %{text: "abc", value: "world"}
           }

  end

  test "multi_select_menu" do
    assert BE.multi_select_menu("placeholder", :multi_users_select, "id") == %{
             action_id: "id",
             placeholder: %{text: "placeholder", type: :plain_text},
             type: :multi_users_select
           }

    assert BE.multi_select_menu("placeholder", :multi_static_select, "id", options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}], initial_options: [0,1]) == %{
             action_id: "id",
             placeholder: %{text: "placeholder", type: :plain_text},
             type: :multi_static_select,
             options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}],
             initial_options: [%{text: "abc", value: "world"}, %{text: "def", value: "hello"}]
           }
    
    assert BE.multi_select_menu("placeholder", :multi_static_select, "id", option_groups: [%{label: "yo", options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}]}], initial_options: [{0,0}, {0,1}]) == %{
             action_id: "id",
             placeholder: %{text: "placeholder", type: :plain_text},
             type: :multi_static_select,
             option_groups: [%{label: "yo", options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}]}],
             initial_options: [%{text: "abc", value: "world"}, %{text: "def", value: "hello"}]
           }
  end
end
