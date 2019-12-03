<!-- ![alt example block creation](https://raw.githubusercontent.com/azohra/BlockBox/master/images/shit_bricks.png) -->

<p align="center">
  <img src="images/shit_bricks.png" width="600" alt="logo">
</p>


# BlockBox

A tool used to generate slack UI blocks using elixir defined functions.

## Motivation

### *Slack blocks are large*

  - As seen above the view is about 3 times larger than the functional definition

### *Reusability*
  
  - Repetition of blocks is reduced across code, the same functions are used and can be changed in a single place

### *Readability*
  
  - It's easier to read functions with parameters instead of large scoped blocks 

## Installation

```elixir
def deps do
  [
    {:blockbox, "~> 1.0.0"}
  ]
end
```

## Usage
`use BlockBox` in whatever module you need it to get access to all the components.
```
  use BlockBox
```

## Example

The following Slack UI view

<!-- ![alt example block creation](https://raw.githubusercontent.com/azohra/BlockBox/master/images/demo.png) -->
<img src="images/demo.png" width="400" alt="example view">

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
  context_actions([text_object("Summarize")], "summ_context",
    elem_type: "context"
  ),
  input("Description", plain_text_input("Write something", true), "description"),
  context_actions([text_object("Describe")], "desc_context",
    elem_type: "context"
  ),
  input(
    "Priority",
    static_select(
      "Select items",
      Enum.map(1..4, fn x ->
        option_object("P" <> Integer.to_string(x), Integer.to_string(x + 5))
      end)
    ),
    "priority"
  ),
  input("Labels", plain_text_input("thing1, thing2, ...", false), "labels")
]
```