defmodule BlockBox.LayoutBlocks do
  @moduledoc """
  Defines generator functions for all [layout blocks](https://api.slack.com/reference/block-kit/blocks).
  """

  alias BlockBox.CompositionObjects, as: CO

  @doc """
    Creates a [section block](https://api.slack.com/reference/block-kit/blocks#section).

    ## Options
    Options are not included by default.
    * `:block_id` - string
    * `:fields` - list of text objects
    * `:accessory` - any [element object](https://api.slack.com/reference/block-kit/block-elements)
  """
  @spec section(String.t() | CO.text_object(), keyword()) :: map()
  def section(text, opts \\ [])

  def section(text, opts) when is_binary(text) do
    CO.text_object(text, :mrkdwn)
    |> section(opts)
  end

  def section(text_object, opts) do
    %{
      type: "section",
      text: text_object
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a [divider block](https://api.slack.com/reference/block-kit/blocks#divider).

    ## Options
    Options are not included by default.
    * `:block_id` - String
  """
  @spec divider(keyword()) :: map()
  def divider(opts \\ []) do
    %{type: "divider"}
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates an [image block](https://api.slack.com/reference/block-kit/blocks#image).

    ## Options
    Options are not included by default.
    * `:title` - plain_text_object or String
    * `:block_id` - String
  """
  @spec image_block(String.t(), String.t(), keyword()) :: map()
  def image_block(image_url, alt_text, opts \\ []) do
    opts =
      case Keyword.get(opts, :title) do
        val when is_binary(val) -> Keyword.put(opts, :title, CO.text_object(val))
        _val -> opts
      end

    %{
      type: "image",
      image_url: image_url,
      alt_text: alt_text
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates an [actions block](https://api.slack.com/reference/block-kit/blocks#actions).

    ## Options
    Options are not included by default.
    * `:block_id` - String
  """
  @spec actions_block(list(), keyword()) :: map()
  def actions_block(elements, opts \\ []) do
    %{
      type: "actions",
      elements: elements
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a [context block](https://api.slack.com/reference/block-kit/blocks#context).

    ## Options
    Options are not included by default.
    * `:block_id` - String
  """
  @spec context_block(list(), keyword()) :: map()
  def context_block(elements, opts \\ []) do
    %{
      type: "context",
      elements: elements
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates an [input block](https://api.slack.com/reference/block-kit/blocks#input).
    ## Options
    Options are not included by default.
    * `:block_id` - String
    * `:hint` - plain_text_object or String
    * `:optional` - boolean
  """
  @spec input(CO.plain_text_object(), map(), keyword()) :: map()
  def input(label, element, opts \\ []) do
    opts =
      case Keyword.get(opts, :hint) do
        val when is_binary(val) -> Keyword.put(opts, :hint, CO.text_object(val))
        _val -> opts
      end

    %{
      type: "input",
      element: element,
      label: label
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a [file block](https://api.slack.com/reference/block-kit/blocks#file).
    ## Options
    Options are not included by default.
    * `:block_id` - String
  """
  def file_block(external_id, source \\ "remote", opts \\ []) do
    %{
      type: "file",
      external_id: external_id,
      source: source
    }
    |> Map.merge(Enum.into(opts, %{}))
  end
end
