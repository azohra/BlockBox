defmodule BlockBox do
  @moduledoc """
  A tool used to generate slack UI blocks using elixir defined functions.

  ## Usage
  The module is available through hex and can be added to your mix.exs file like so:
    ```elixir
    def deps do
      [
        {:blockbox, "~> 0.0.2"}
      ]
    end
    ```
  BlockBox can be imported as follows:
    ```
      import BlockBox
    ```
  Additionally, the using macro is available as follows:
    ```
      use BlockBox
    ```
  """
  @doc """
    Function that generates a text struct
    Required parameter ->
      text: String
    Optional keys in the keyword list are as follows with their default values
      type: String \\ "mrkdwn"
      emoji_bool: emoji \\ false
  """
  @spec text_info(String.t(), list()) :: map()
  def text_info(text, klist \\ []) do
    type = Keyword.get(klist, :type, "mrkdwn")
    emoji_bool = Keyword.get(klist, :emoji_bool, false)

    result = %{
      "type" => type,
      "text" => text
    }

    case emoji_bool,
      do:
        (
          false -> result
          _ -> Map.put(result, "emoji", emoji_bool)
        )
  end

  @doc """
    Function that generates an option for select blocks
    Required parameters ->
      display_text: String
      opt_value: option_type
  """
  @spec generate_option(String.t(), String.t()) :: map()
  def generate_option(display_text, opt_value) do
    option = %{
      "text" => text_info(display_text, type: "plain_text", emoji_bool: true),
      "value" => opt_value
    }
  end

  @doc """
    Creates a divider block
  """
  @spec divider() :: map()
  def divider do
    %{
      "type" => "divider"
    }
  end

  @doc """
    Creates a plain text input block
    Required parameters ->
      placeholder: String
      multiline_bool: Boolean
    Optional keys ->  
      action_id: String 
  """
  @spec plain_text_input(String.t(), boolean()) :: map()
  def plain_text_input(placeholder, multiline) do
    %{
      "type" => "plain_text_input",
      "multiline" => multiline,
      "placeholder" => text_info(placeholder, type: "plain_text", emoji_bool: true)
    }
  end

  @doc """
    Creates a input block
    Required parameters ->
      text: String
      element: map()
      block_id: String
    Optional parameters -> 
      optional: Boolean \\ false
  """
  @spec input(String.t(), map(), String.t(), list()) :: map()
  def input(text, elem, block_id, klist \\ []) do
    optional = Keyword.get(klist, :optional, false)
    input = %{
      "type" => "input",
      "element" => elem,
      "block_id" => block_id,
      "label" => text_info(text, type: "plain_text", emoji_bool: true)
    }
    case optional,
      do:
        (
          false -> input
          _ -> Map.put(input, "optional", true)
        )

  end

  @doc """
    Creates a context or actions block depending on type provided
    Required parameters ->
      elements: list of elements
      bid: String
    Optional keys ->
      elem_type: String \\ "context"
  """
  @spec context_actions(list(), String.t(), keyword()) :: map()
  def context_actions(elements, block_id, klist \\ []) do
    elem_type = Keyword.get(klist, :elem_type, "context")

    %{
      "type" => elem_type,
      "elements" => elements,
      "block_id" => block_id
    }
  end

  @doc """
    Creates a section block
    Required parameters ->
      text: String
      type: String
    Optional keys ->
      accessory: other block
      block_id: String
  """
  @spec section(String.t(), keyword()) :: map()
  def section(text, klist \\ []) do
    acc = Keyword.get(klist, :accessory, false)
    bid = Keyword.get(klist, :block_id, false)

    result = %{
      "type" => "section",
      "text" => text_info(text)
    }

    result_bid =
      case bid,
        do:
          (
            false -> result
            _ -> Map.put(result, "block_id", bid)
          )

    case acc,
      do:
        (
          false -> result_bid
          _ -> Map.put(result_bid, "accessory", acc)
        )
  end

  @doc """
    Creates a multi select user block
    Required parameters ->
      placeholder_text: String
  """
  @spec multi_select_users(String.t()) :: map()
  def multi_select_users(placeholder_text) do
    %{
      "type" => "multi_users_select",
      "placeholder" => text_info(placeholder_text, type: "plain_text", emoji_bool: true)
    }
  end

  @doc """
    Creates a static select block
    Required parameters ->
      text: String
      options: list()
    Optional keys ->
      initial: index
      type: String \\ "static_select" (Specifies select type)
  """
  @spec static_select(String.t(), list(), list()) :: map()
  def static_select(text, options, klist \\ []) do
    type = Keyword.get(klist, :type, "static_select")
    initial = Keyword.get(klist, :initial, false)

    result = %{
      "type" => type,
      "placeholder" => text_info(text, type: "plain_text", emoji_bool: true),
      "options" => options
    }

    case initial,
      do:
        (
          false -> result
          _ -> Map.put(result, "initial_option", Enum.at(options, initial))
        )
  end

  @doc """
    Creates a date block
    Required parameters ->
      date: String (Date string)
      placeholder_text: String
  """
  @spec date_block(String.t(), String.t()) :: map()
  def date_block(date, placeholder_text) do
    %{
      type: "datepicker",
      initial_date: date,
      placeholder: text_info(placeholder_text, type: "plain_text", emoji_bool: true)
    }
  end

  @doc """
    Creates a button block
    Required parameters ->
      text: String
      value: String
  """
  @spec button_block(String.t(), String.t()) :: map()
  def button_block(text, value) do
    %{
      "type" => "button",
      "text" => %{
        "type" => "plain_text",
        "text" => text
      },
      "value" => value
    }
  end

  @doc """
    Creates an image block
    Required parameters ->
      image_url: String
      alt_text: String
  """
  @spec image_block(String.t(), String.t()) :: map()
  def image_block(image_url, alt_text) do
    %{
      type: "image",
      image_url: image_url,
      alt_text: alt_text
    }
  end

  @doc """
    Parses the block submissions to extract the block_id:block_value key-value pairs
  """
  @spec get_submission_values(map()) :: map()
  def get_submission_values(list_maps) do
    Enum.reduce(list_maps, %{}, fn {k, v}, acc ->
      result = _get_val(v)

      case is_list(result) do
        true ->
          [head | tail] = result

          case tail == [] do
            true -> Map.put(acc, k, head)
            false -> Map.put(acc, k, result)
          end

        false ->
          acc
      end
    end)
  end

  defp _get_val(list_val) when is_list(list_val) do
    Enum.reduce(list_val, [], fn v, acc ->
      acc ++ _get_val(v)
    end)
  end

  defp _get_val(map_val) when is_map(map_val) do
    val = Map.get(map_val, "value", false)

    val =
      case val,
        do:
          (
            false -> Map.get(map_val, "selected_date", false)
            _ -> val
          )

    val =
      case val,
        do:
          (
            false -> Map.get(map_val, "selected_users", false)
            _ -> val
          )

    case val do
      false ->
        Enum.reduce(map_val, [], fn {k, v}, acc ->
          vals = _get_val(v)

          case vals == [] or vals == nil do
            true -> acc
            false -> acc ++ vals
          end
        end)

      _ ->
        [val]
    end
  end

  defp _get_val(val) do
    nil
  end

  defmacro __using__(_opts) do
    quote do
      defdelegate text_info(text, klist \\ []), to: BlockBox
      defdelegate generate_option(display_text, opt_value), to: BlockBox
      defdelegate divider, to: BlockBox
      defdelegate plain_text_input(placeholder, multiline), to: BlockBox
      defdelegate input(text, elem, block_id), to: BlockBox
      defdelegate context_actions(elements, block_id, klist \\ []), to: BlockBox
      defdelegate section(text, klist \\ []), to: BlockBox
      defdelegate multi_select_users(placeholder_text), to: BlockBox
      defdelegate static_select(text, options, klist \\ []), to: BlockBox
      defdelegate date_block(date, placeholder_text), to: BlockBox
      defdelegate button_block(text, value), to: BlockBox
      defdelegate image_block(image_url, alt_text), to: BlockBox
      defdelegate get_submission_values(list_maps), to: BlockBox
    end
  end
end
