defmodule BlockBox.LayoutBlocksTest do
  use ExUnit.Case
  alias BlockBox.LayoutBlocks, as: LB

  test "section" do
    assert LB.section("text") == %{text: %{text: "text", type: :mrkdwn}, type: "section"}
  end

  test "divider" do
    assert LB.divider() == %{type: "divider"}
    assert LB.divider(block_id: "id") == %{block_id: "id", type: "divider"}
  end

  test "image_block" do
    assert LB.image_block("url", "alt_text") == %{
             alt_text: "alt_text",
             image_url: "url",
             type: "image"
           }

    assert LB.image_block("url", "alt_text", title: "title") == %{
             alt_text: "alt_text",
             image_url: "url",
             type: "image",
             title: %{text: "title", type: :plain_text}
           }

    assert LB.image_block("url", "alt_text", title: %{text: "title", type: :plain_text}) == %{
             alt_text: "alt_text",
             image_url: "url",
             type: "image",
             title: %{text: "title", type: :plain_text}
           }
  end

  test "actions_block" do
    assert LB.actions_block(["my_element"]) == %{elements: ["my_element"], type: "actions"}
  end

  test "context_block" do
    assert LB.context_block(["my_element"]) == %{elements: ["my_element"], type: "context"}
  end

  test "input" do
    assert LB.input("label", "my_element") == %{
             element: "my_element",
             label: %{text: "label", type: :plain_text},
             type: "input"
           }

    assert LB.input("label", "my_element", hint: "hint") == %{
             element: "my_element",
             label: %{text: "label", type: :plain_text},
             type: "input",
             hint: %{text: "hint", type: :plain_text}
           }
  end

  test "file_block" do
    assert LB.file_block("extern_id") == %{
             external_id: "extern_id",
             source: "remote",
             type: "file"
           }
  end
end
