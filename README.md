# BlockBox

A tool used to generate slack UI blocks using elixir defined functions.

## Example

This following Slack UI view

![alt example block creation](https://raw.githubusercontent.com/azohra/BlockBox/master/images/demo.png)

has the elixir structure shown below

```
[
  %{"type" => "divider"},
  %{
    "block_id" => "summary",
    "element" => %{"type" => "plain_text_input"},
    "label" => %{"emoji" => true, "text" => "Summary", "type" => "plain_text"},
    "type" => "input"
  },
  %{
    "block_id" => "summ_context",
    "elements" => [%{"text" => "Summarize", "type" => "mrkdwn"}],
    "type" => "context"
  },
  %{
    "block_id" => "description",
    "element" => %{
      "multiline" => true,
      "placeholder" => %{
        "emoji" => true,
        "text" => "Write something",
        "type" => "plain_text"
      },
      "type" => "plain_text_input"
    },
    "label" => %{
      "emoji" => true,
      "text" => "Description",
      "type" => "plain_text"
    },
    "type" => "input"
  },
  %{
    "block_id" => "desc_context",
    "elements" => [%{"text" => "Describe", "type" => "mrkdwn"}],
    "type" => "context"
  },
  %{
    "block_id" => "priority",
    "element" => %{
      "options" => [
        %{
          "text" => %{"emoji" => true, "text" => "P1", "type" => "plain_text"},
          "value" => "6"
        },
        %{ 
          "text" => %{"emoji" => true, "text" => "P2", "type" => "plain_text"},
          "value" => "7"
        },
        %{
          "text" => %{"emoji" => true, "text" => "P3", "type" => "plain_text"},
          "value" => "8"
        },
        %{
          "text" => %{"emoji" => true, "text" => "P4", "type" => "plain_text"},
          "value" => "9"
        }
      ],
      "placeholder" => %{
        "emoji" => true,
        "text" => "Select items",
        "type" => "plain_text"
      },
      "type" => "static_select"
    },
    "label" => %{"emoji" => true, "text" => "Priority", "type" => "plain_text"},
    "type" => "input"
  },
  %{
    "block_id" => "labels",
    "element" => %{
      "multiline" => false,
      "placeholder" => %{
        "emoji" => true,
        "text" => "thing1, thing2, ...",
        "type" => "plain_text"
      },
      "type" => "plain_text_input"
    },
    "label" => %{"emoji" => true, "text" => "Labels", "type" => "plain_text"},
    "type" => "input"
  }
]
```

using BlockBox the structure can be simplified to 

```
[
  divider(),
  input("Summary", %{"type" => "plain_text_input"}, "summary"),
  context_actions([text_info("Summarize")], "summ_context",
    elem_type: "context"
  ),
  input("Description", plain_text_input("Write something", true), "description"),
  context_actions([text_info("Describe")], "desc_context",
    elem_type: "context"
  ),
  input(
    "Priority",
    static_select(
      "Select items",
      Enum.map(1..4, fn x ->
        generate_option("P" <> Integer.to_string(x), Integer.to_string(x + 5))
      end)
    ),
    "priority"
  ),
  input("Labels", plain_text_input("thing1, thing2, ...", false), "labels")
]
```

## Motivations

### *Slack blocks are large*

  - As seen above the view is about 3 times larger than the functional definition

### *Allows for Reusability*
  
  - Entire UI flows can be created with block functions

### *Increases overall readability*
  
  - Easier to read functions with parameters over large scoped blocks 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `blockbox` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:blockbox, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/blockbox](https://hexdocs.pm/blockbox).

