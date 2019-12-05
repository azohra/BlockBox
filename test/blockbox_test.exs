defmodule BlockBoxTest do
  use ExUnit.Case, async: true
  doctest BlockBox
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

  test "test get_submission_values with optionals" do
    assert get_submission_values(@submission_with_optionals, :block_id) == %{
             "attachments" => ["1", "2"],
             "description" => "test-123",
             "labels" => "test-123",
             "priority" => "9",
             "summary" => "test-123",
             "watchers" => ["11221", "12D123"]
           }
  end

  test "test get_submission_values without optionals" do
    assert get_submission_values(@submission_without_optionals, :block_id) == %{
             "description" => "test-123",
             "labels" => "test-123",
             "priority" => "9",
             "summary" => "test-123"
           }
  end
end
