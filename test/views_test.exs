defmodule BlockBox.ViewsTest do
  use ExUnit.Case
  alias BlockBox.Views, as: Views

  test "build_view" do
    assert Views.build_view(:modal, "title", []) == %{
             blocks: [],
             type: :modal,
             title: %{text: "title", type: :plain_text}
           }

    assert Views.build_view(:modal, "title", [], submit: "submit", close: "close") == %{
             blocks: [],
             submit: %{text: "submit", type: :plain_text},
             title: %{text: "title", type: :plain_text},
             type: :modal,
             close: %{text: "close", type: :plain_text}
           }
  end
end
