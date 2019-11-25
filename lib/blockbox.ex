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
  # "plain_text" | "mrkdwn"
  @type text_type() :: :plain_text | :mrkdwn

  @type select_menu_type() ::
          :external_select | :users_select | :conversations_select | :channels_select

  @type multi_select_menu_type() ::
          :multi_external_select
          | :multi_users_select
          | :multi_conversations_select
          | :multi_channels_select

  @type text_info() :: %{
          required(:text) => String.t(),
          required(:type) => text_type(),
          optional(:emoji) => boolean(),
          optional(:verbatim) => boolean()
        }

  @type option() :: %{
          required(:text) => text_info(),
          required(:value) => String.t(),
          optional(:url) => String.t()
        }

  @doc """
    Function that generates a text struct
    Optional keys in the keyword list are as follows with their default values
      emoji: boolean \\ false
      verbatim: boolean \\ false
  """
  @spec text_info(String.t(), text_type(), keyword()) :: text_info()
  def text_info(text, type \\ :plain_text, opts \\ []) do
    %{
      type: type,
      text: text
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Function that generates an option for select blocks
    options ->
      url: String
  """
  @spec generate_option(text_info(), String.t(), keyword()) :: option()
  def generate_option(text_info, opt_value, opts) do
    %{
      text: text_info,
      value: opt_value
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a divider block
  """
  @spec divider() :: map()
  def divider do
    %{type: "divider"}
  end

  @doc """
    Creates a plain text input block
    Optional keys ->
      placeholder: text_info()
      multiline: Boolean
      action_id: String
      initial_value: String
      min_length: Integer
      max_length: integer
    see https://api.slack.com/reference/block-kit/block-elements#input for options
  """
  @spec plain_text_input(keyword()) :: map()
  def plain_text_input(opts) do
    %{type: "plain_text_input"}
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a input block
    Required parameters ->
      text: String
      element: map()
    Optional parameters ->
      optional: Boolean \\ false
      block_id: String
      hint: text_info
  """
  @spec input(text_info(), map(), list()) :: map()
  def input(label, element, opts \\ []) do
    %{
      type: "input",
      element: element,
      label: label
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a context or actions block depending on type provided
    Required parameters ->
      elements: list of elements
    Optional keys ->
      block_id: String
  """
  @spec context_actions(list(), keyword()) :: map()
  def context_actions(elements, opts \\ []) do
    %{
      type: "context",
      elements: elements
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a section block
    Required parameters ->
      text: String
      type: String
    Optional keys ->
      accessory: any element object
      block_id: String,
      fields: list(text_info())
  """
  @spec section(text_info(), keyword()) :: map()
  def section(text_info, opts \\ []) do
    %{
      type: "section",
      text: text_info
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @spec select_menu(
          select_menu_type() | multi_select_menu_type(),
          text_info(),
          String.t(),
          keyword()
        ) ::
          map()
  def select_menu(type, placeholder, action_id, opts) do
    %{
      type: type,
      placeholder: placeholder,
      action_id: action_id
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
  @spec static_select(text_info(), list(), list()) :: map()
  def static_select(text_info, options, klist \\ []) do
    type = Keyword.get(klist, :type, "static_select")
    initial = Keyword.get(klist, :initial, false)

    result = %{
      type: type,
      placeholder: text_info,
      options: options
    }

    case initial do
      false -> result
      _ -> Map.put(result, "initial_option", Enum.at(options, initial))
    end
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
  @spec button_block(String.t(), String.t(), String.t()) :: map()
  def button_block(text, value, type \\ "plain_text") do
    %{
      type: "button",
      text: %{
        type: type,
        text: text
      },
      value: value
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

      case result do
        [head | []] -> Map.put(acc, k, head)
        [_head | _tail] -> Map.put(acc, k, result)
        [] -> acc
        _ -> acc
      end
    end)
  end

  defp _get_val(list_val) when is_list(list_val) do
    Enum.reduce(list_val, [], fn v, acc ->
      result_val = _get_val(v)

      case result_val do
        nil -> acc
        _ -> acc ++ _get_val(v)
      end
    end)
  end

  defp _get_val(map_val) when is_map(map_val) do
    val = Map.get(map_val, "value", false)

    val =
      case val do
        false -> Map.get(map_val, "selected_date", false)
        _ -> val
      end

    val =
      case val do
        false -> Map.get(map_val, "selected_users", false)
        _ -> val
      end

    case val do
      false ->
        Enum.reduce(map_val, [], fn {_k, v}, acc ->
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

  defp _get_val(_val) do
    nil
  end

  defmacro __using__(_opts) do
    quote do
      defdelegate text_info(text, klist \\ []), to: BlockBox
      defdelegate generate_option(display_text, opt_value), to: BlockBox
      defdelegate divider, to: BlockBox
      defdelegate plain_text_input(placeholder, multiline), to: BlockBox
      defdelegate input(text, elem, block_id, klist \\ []), to: BlockBox
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
