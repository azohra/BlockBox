defmodule BlockBox.CompositionObjects do
  @moduledoc """
  Defines types and generator functions for all [composition objects](https://api.slack.com/reference/block-kit/composition-objects).
  """

  alias BlockBox.Utils, as: Utils

  @type text_type() :: :plain_text | :mrkdwn

  @type text_object() :: %{
          required(:text) => String.t(),
          required(:type) => text_type(),
          optional(:emoji) => boolean(),
          optional(:verbatim) => boolean()
        }

  @type plain_text_object() :: %{
          required(:text) => String.t(),
          required(:type) => :plain_text,
          optional(:emoji) => boolean()
        }

  @type confirm_object() :: %{
          required(:title) => plain_text_object(),
          required(:text) => text_object(),
          required(:confirm) => plain_text_object(),
          required(:deny) => plain_text_object()
        }

  @type option_object() :: %{
          required(:text) => text_object(),
          required(:value) => String.t(),
          optional(:description) => plain_text_object(),
          optional(:url) => String.t()
        }

  @type option_group_object() :: %{
          required(:label) => plain_text_object(),
          required(:options) => list(option_object())
        }

  @type filter_object() :: %{
          optional(:include) => list(String.t()),
          optional(:exclude_external_shared_channels) => boolean(),
          optional(:exclude_bot_users) => boolean()
        }

  @doc """
  Function that generates a [text object](https://api.slack.com/reference/block-kit/composition-objects#text)

  ## Options
  Options are not included by default.
  * `:emoji` - boolean, only usable when type is `:plain_text`
  * `:verbatim` - boolean, only usable when type is `:mrkdwn`
  """
  @spec text_object(String.t(), text_type(), keyword()) :: text_object()
  def text_object(text, type \\ :plain_text, opts \\ []) do
    %{
      type: type,
      text: text
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
  Function that generates a [confirmation dialog object](https://api.slack.com/reference/block-kit/composition-objects#confirm)
  """
  @spec confirm_object(String.t(), String.t(), String.t(), String.t()) :: confirm_object()
  def confirm_object(title, text, confirm \\ "Confirm", deny \\ "Deny") do
    %{
      title: text_object(title),
      text: text_object(text),
      confirm: text_object(confirm),
      deny: text_object(deny)
    }
  end

  @doc """
  Function that generates an [option object](https://api.slack.com/reference/block-kit/composition-objects#option) for select menus
  ## Options
  Options are not included by default.
  * `:url` - boolean, only available in overflow menus
  * `:description` - String, max 75 chars
  """
  def option_object(text, value, opts \\ [])

  @spec option_object(String.t() | plain_text_object(), String.t(), keyword()) :: option_object()
  def option_object(text_str, value, opts) when is_binary(text_str) do
    text_object(text_str)
    |> option_object(value, opts)
  end

  def option_object(text_object, value, opts) do
    opts = Utils.convert_text_opts(opts, [:description])

    %{
      text: text_object,
      value: value
    }
    |> Map.merge(Enum.into(opts, %{}))
  end

  @doc """
  Function that generates an [option group object](https://api.slack.com/reference/block-kit/composition-objects#option_group) for select menus
  """
  @spec option_group_object(String.t() | plain_text_object(), String.t()) :: option_group_object()
  def option_group_object(label, options) when is_binary(label) do
    text_object(label)
    |> option_group_object(options)
  end

  def option_group_object(label, options) do
    %{
      label: label,
      options: options
    }
  end

  @doc """
  Function that generates a [filter object](https://api.slack.com/reference/block-kit/composition-objects#filter_conversations) for conversation lists.

  All fields are optional but AT LEAST ONE MUST BE INCLUDED.
  ## Options
  Options are not included by default.
  * `:include` - non empty list of strings from the following options: "im", "mpim", "private", "public"
  * `:exclude_external_shared_channels` - boolean, defaults to false
  * `:exclude_bot_users` - boolean, defaults to false
  """
  def filter_object(opts) do
    Enum.into(opts, %{})
  end
end
