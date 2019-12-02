defmodule BlockBox.BlockElements do
  @moduledoc """
  Defines generator functions for all [block elements](https://api.slack.com/reference/block-kit/block-elements).
  """

  alias BlockBox.CompositionObjects, as: CO

  @type select_menu_type ::
          :static_select
          | :external_select
          | :users_select
          | :conversations_select
          | :channels_select

  @type multi_select_menu_type ::
          :multi_static_select
          | :multi_external_select
          | :multi_users_select
          | :multi_conversations_select
          | :multi_channels_select

  @doc """
    Creates a [button element](https://api.slack.com/reference/block-kit/block-elements#button).

    ## Options
    Options are not included by default.
    * `:url` - String
    * `:value` - String
    * `:style` - String
    * `:confirm` - `CO.confirm_object`
  """
  @spec button(String.t() | CO.text_object(), String.t(), keyword()) :: map()
  def button(text, action_id, opts \\ [])

  def button(text, action_id, opts) when is_binary(text) do
    CO.text_object(text)
    |> button(action_id, opts)
  end

  def button(text, action_id, opts) do
    %{
      type: "button",
      text: text,
      action_id: action_id
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a [datepicker element](https://api.slack.com/reference/block-kit/block-elements#datepicker).

    ## Options
    Options are not included by default.
    * `:placeholder` - `CO.plain_text_object` or String
    * `:initial_date` - String, "YYYY-MM-DD" format
    * `:confirm` - `CO.confirm_object`
  """
  @spec datepicker(String.t(), keyword()) :: map()
  def datepicker(action_id, opts \\ []) do
    opts =
      case Keyword.get(opts, :placeholder) do
        val when is_binary(val) -> Keyword.put(opts, :placeholder, CO.text_object(val))
        _val -> opts
      end

    %{type: "datepicker", action_id: action_id}
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates an [image element](https://api.slack.com/reference/block-kit/block-elements#image).
  """
  @spec image(String.t(), String.t()) :: map()
  def image(image_url, alt_text) do
    %{
      type: "image",
      image_url: image_url,
      alt_text: alt_text
    }
  end

  @doc """
    Creates an [overflow menu element](https://api.slack.com/reference/block-kit/block-elements#overflow).

    ## Options
    Options are not included by default.
    * `:confirm` - `CO.confirm_object`
  """
  @spec overflow_menu(String.t(), list(CO.option_object()), keyword()) :: map()
  def overflow_menu(action_id, options, opts \\ []) do
    %{
      type: "overflow",
      action_id: action_id,
      options: options
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a [plain text input element](https://api.slack.com/reference/block-kit/block-elements#input).

    ## Options
    Options are not included by default.
    * `:placeholder` - `CO.plain_text_object` or String
    * `:initial_value` - String
    * `:multiline` - boolean
    * `:min_length` - non negative integer
    * `:max_length` - positive integer
  """
  @spec plain_text_input(String.t(), keyword()) :: map()
  def plain_text_input(action_id, opts \\ []) do
    opts =
      case Keyword.get(opts, :placeholder) do
        val when is_binary(val) -> Keyword.put(opts, :placeholder, CO.text_object(val))
        _val -> opts
      end

    %{type: "plain_text_input", action_id: action_id}
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a [radio button group element](https://api.slack.com/reference/block-kit/block-elements#radio).

    ## Options
    Options are not included by default.
    * `:initial_option` - `CO.option_object`
    * `:confirm` - `CO.confirm_object`
  """
  @spec radio_buttons(String.t(), list(CO.option_object()), keyword()) :: map()
  def radio_buttons(action_id, options, opts \\ []) do
    %{
      type: "radio_buttons",
      action_id: action_id,
      options: options
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a [select menu element](https://api.slack.com/reference/block-kit/block-elements#select).

    *ONLY ONE* of the following k/v pairs must be included in the options:
    * `:options` - a list of `CO.option_object`s
    * `:option_groups` - a list of `CO.option_group_object`s

    ## Options
    Options are not included by default.
    * `:initial_option` - `CO.option_object`, only available with [static_select](https://api.slack.com/reference/block-kit/block-elements#static_select) or [external_select](https://api.slack.com/reference/block-kit/block-elements#external_select) types
    * `:min_query_length` - positive integer, only available with [external_select](https://api.slack.com/reference/block-kit/block-elements#external_select) type
    * `:initial_user` - slack user ID, only available with [users_select](https://api.slack.com/reference/block-kit/block-elements#users_select) type
    * `:initial_conversation` - slack conversation ID, only available with [conversations_select](https://api.slack.com/reference/block-kit/block-elements#conversation_select) type
    * `:initial_channel` -  slack channel ID, only available with [channels_select](https://api.slack.com/reference/block-kit/block-elements#channel_select) type
    * `:confirm` - `CO.confirm_object`
  """
  @spec select_menu(
          String.t() | CO.plain_text_object(),
          select_menu_type | multi_select_menu_type,
          String.t(),
          keyword()
        ) :: map()
  def select_menu(placeholder, type, action_id, opts \\ [])

  def select_menu(placeholder, type, action_id, opts) when is_binary(placeholder) do
    CO.text_object(placeholder)
    |> select_menu(type, action_id, opts)
  end

  def select_menu(placeholder, type, action_id, opts) do
    %{type: type, placeholder: placeholder, action_id: action_id}
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
    Creates a [multi-select menu element](https://api.slack.com/reference/block-kit/block-elements#multi_select).

    *ONLY ONE* of the following k/v pairs must be included in the options:
    * `:options` - a list of `CO.option_object`s
    * `:option_groups` - a list of `CO.option_group_object`s

    ## Options
    Options are not included by default.
    * `:initial_options` - list of `CO.option_object`s, only available with [multi_static_select](https://api.slack.com/reference/block-kit/block-elements#static_multi_select) or [external_select](https://api.slack.com/reference/block-kit/block-elements#external_multi_select) types
    * `:min_query_length` - positive integer, only available with [multi_external_select](https://api.slack.com/reference/block-kit/block-elements#external_multi_select) type
    * `:initial_users` - list of slack user IDs, only available with [multi_users_select](https://api.slack.com/reference/block-kit/block-elements#users_multi_select) type
    * `:initial_conversations` - list of slack conversation IDs, only available with [multi_conversations_select](https://api.slack.com/reference/block-kit/block-elements#conversation_multi_select) type
    * `:initial_channels` - list of slack channel IDs, only available with [multi_channels_select](https://api.slack.com/reference/block-kit/block-elements#channel_multi_select) type
    * `:confirm` - `CO.confirm_object`
  """
  @spec multi_select_menu(
          String.t() | CO.plain_text_object(),
          multi_select_menu_type,
          String.t(),
          keyword()
        ) :: map()
  def multi_select_menu(placeholder, type, action_id, opts \\ []) do
    select_menu(placeholder, type, action_id, opts)
  end
end
