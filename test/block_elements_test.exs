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
end
