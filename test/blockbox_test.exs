defmodule BlockboxTest do
  use ExUnit.Case
  use BlockBox

  @submission_with_optionals %{
    "attachments" => %{
      "qtgL" => %{
        "type" => "multi_static_select",
        "selected_options" => [%{"value" => "1"}, %{"value" => "2"}]
      }
    },
    "description" => %{
      "42NY" => %{"type" => "plain_text_input", "value" => "test-123"}
    },
    "labels" => %{
      "21FdK" => %{"type" => "plain_text_input", "value" => "test-123"}
    },
    "priority" => %{
      "tV4vB" => %{
        "selected_option" => %{
          "text" => %{"emoji" => true, "text" => "P4", "type" => "plain_text"},
          "value" => "9"
        },
        "type" => "static_select"
      }
    },
    "summary" => %{
      "BhPhP" => %{"type" => "plain_text_input", "value" => "test-123"}
    },
    "watchers" => %{
      "Po1WR" => %{"type" => "multi_users_select", "selected_users" => ["11221", "12D123"]}
    }
  }
  @submission_without_optionals %{
    "attachments" => %{"qtgL" => %{"type" => "multi_static_select"}},
    "description" => %{
      "42NY" => %{"type" => "plain_text_input", "value" => "test-123"}
    },
    "labels" => %{
      "21FdK" => %{"type" => "plain_text_input", "value" => "test-123"}
    },
    "priority" => %{
      "tV4vB" => %{
        "selected_option" => %{
          "text" => %{"emoji" => true, "text" => "P4", "type" => "plain_text"},
          "value" => "9"
        },
        "type" => "static_select"
      }
    },
    "summary" => %{
      "BhPhP" => %{"type" => "plain_text_input", "value" => "test-123"}
    },
    "watchers" => %{"Po1WR" => %{"type" => "multi_users_select"}}
  }
  @elements %{
    "text" => %{"text" => "Click Here", "type" => "plain_text"},
    "type" => "button",
    "value" => "output"
  }
  @text_element %{"type" => "plain_text_input"}
  test "test button_block" do
    assert button_block("Click Here", "output") == @elements
  end

  test "test context_actions as context" do
    assert context_actions([@elements], "bid1") == %{
             "type" => "context",
             "block_id" => "bid1",
             "elements" => [@elements]
           }
  end

  test "test context_actions as actions" do
    assert context_actions([@elements], "bid1", elem_type: "actions") == %{
             "type" => "actions",
             "block_id" => "bid1",
             "elements" => [@elements]
           }
  end

  test "test date_block" do
    assert date_block("11-10-19", "Input date") == %{
             :initial_date => "11-10-19",
             :placeholder => %{"emoji" => true, "text" => "Input date", "type" => "plain_text"},
             :type => "datepicker"
           }
  end

  test "test divider" do
    assert divider() == %{"type" => "divider"}
  end

  test "test option_object" do
    assert option_object("option1", "opt_value") == %{
             "text" => %{
               "emoji" => true,
               "text" => "option1",
               "type" => "plain_text"
             },
             "value" => "opt_value"
           }
  end

  test "test image_block" do
    assert image_block("image_url", "alt text") == %{
             :alt_text => "alt text",
             :image_url => "image_url",
             :type => "image"
           }
  end

  test "input block not optional" do
    assert input("input box", @text_element, "bid2") == %{
             "block_id" => "bid2",
             "element" => %{"type" => "plain_text_input"},
             "label" => %{
               "emoji" => true,
               "text" => "input box",
               "type" => "plain_text"
             },
             "type" => "input"
           }
  end

  test "input block optional" do
    assert input("input box", @text_element, "bid2", optional: true) == %{
             "block_id" => "bid2",
             "element" => %{"type" => "plain_text_input"},
             "label" => %{
               "emoji" => true,
               "text" => "input box",
               "type" => "plain_text"
             },
             "optional" => true,
             "type" => "input"
           }
  end

  test "test multi_user_select" do
    assert multi_select_users("multi_user_select") == %{
             "placeholder" => %{
               "emoji" => true,
               "text" => "multi_user_select",
               "type" => "plain_text"
             },
             "type" => "multi_users_select"
           }
  end

  test "test plain text input" do
    assert plain_text_input("placeholder", true) == %{
             "multiline" => true,
             "placeholder" => %{
               "emoji" => true,
               "text" => "placeholder",
               "type" => "plain_text"
             },
             "type" => "plain_text_input"
           }
  end

  test "test section" do
    assert section("section1") == %{
             "text" => %{"text" => "section1", "type" => "plain_text"},
             "type" => "section"
           }
  end

  test "test section with block id and accessory" do
    assert section("section1", accessory: @elements, block_id: "sect_block") == %{
             "accessory" => %{
               "text" => %{"text" => "Click Here", "type" => "plain_text"},
               "type" => "button",
               "value" => "output"
             },
             "block_id" => "sect_block",
             "text" => %{"text" => "section1", "type" => "plain_text"},
             "type" => "section"
           }
  end

  test "test static select" do
    assert static_select(
             "static-select",
             Enum.map(1..5, fn num -> option_object("#{num}", "#{num}") end)
           ) ==
             %{
               "options" => [
                 %{
                   "text" => %{
                     "emoji" => true,
                     "text" => "1",
                     "type" => "plain_text"
                   },
                   "value" => "1"
                 },
                 %{
                   "text" => %{
                     "emoji" => true,
                     "text" => "2",
                     "type" => "plain_text"
                   },
                   "value" => "2"
                 },
                 %{
                   "text" => %{
                     "emoji" => true,
                     "text" => "3",
                     "type" => "plain_text"
                   },
                   "value" => "3"
                 },
                 %{
                   "text" => %{
                     "emoji" => true,
                     "text" => "4",
                     "type" => "plain_text"
                   },
                   "value" => "4"
                 },
                 %{
                   "text" => %{
                     "emoji" => true,
                     "text" => "5",
                     "type" => "plain_text"
                   },
                   "value" => "5"
                 }
               ],
               "placeholder" => %{
                 "emoji" => true,
                 "text" => "static-select",
                 "type" => "plain_text"
               },
               "type" => "static_select"
             }
  end

  test "test multi select with initial" do
    assert static_select(
             "static-select",
             Enum.map(1..5, fn num -> option_object("#{num}", "#{num}") end),
             initial: 0,
             type: "multi-select"
           ) == %{
             "initial_option" => %{
               "text" => %{
                 "emoji" => true,
                 "text" => "1",
                 "type" => "plain_text"
               },
               "value" => "1"
             },
             "options" => [
               %{
                 "text" => %{
                   "emoji" => true,
                   "text" => "1",
                   "type" => "plain_text"
                 },
                 "value" => "1"
               },
               %{
                 "text" => %{
                   "emoji" => true,
                   "text" => "2",
                   "type" => "plain_text"
                 },
                 "value" => "2"
               },
               %{
                 "text" => %{
                   "emoji" => true,
                   "text" => "3",
                   "type" => "plain_text"
                 },
                 "value" => "3"
               },
               %{
                 "text" => %{
                   "emoji" => true,
                   "text" => "4",
                   "type" => "plain_text"
                 },
                 "value" => "4"
               },
               %{
                 "text" => %{
                   "emoji" => true,
                   "text" => "5",
                   "type" => "plain_text"
                 },
                 "value" => "5"
               }
             ],
             "placeholder" => %{
               "emoji" => true,
               "text" => "static-select",
               "type" => "plain_text"
             },
             "type" => "multi-select"
           }
  end

  test "test text info" do
    assert text_object("text1") == %{"text" => "text1", "type" => "plain_text"}
  end

  test "test text info with plain text type and emojis to true" do
    assert text_object("text1", type: "plain_text", emoji_bool: true) == %{
             "text" => "text1",
             "type" => "plain_text",
             "emoji" => true
           }
  end

  test "test get_submission_values with optionals" do
    assert get_submission_values(@submission_with_optionals) == %{
             "attachments" => ["1", "2"],
             "description" => "test-123",
             "labels" => "test-123",
             "priority" => "9",
             "summary" => "test-123",
             "watchers" => ["11221", "12D123"]
           }
  end

  test "test get_submission_values without optionals" do
    assert get_submission_values(@submission_without_optionals) == %{
             "description" => "test-123",
             "labels" => "test-123",
             "priority" => "9",
             "summary" => "test-123"
           }
  end
end
