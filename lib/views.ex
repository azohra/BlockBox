defmodule BlockBox.Views do
  @moduledoc """
  Provides a generator for creating [views](https://api.slack.com/reference/surfaces/views)
  """
  alias BlockBox.CompositionObjects, as: CO
  alias BlockBox.Utils, as: Utils

  @type view_type :: :modal | :home

  @doc """
    Creates a [view payload](https://api.slack.com/reference/surfaces/views).

    ## Options
    Options are not included by default.
    * `:close` - `CO.text_object` String
    * `:submit` - `CO.text_object` String
    * `:private_metadata` - String
    * `:callback_id` - String
    * `:clear_on_close` - boolean
    * `:notify_on_close` - boolean
    * `:external_id` - String
  """
  @spec build_view(view_type, String.t() | CO.plain_text_object(), list(map()), keyword()) ::
          map()
  def build_view(type, title, blocks, opts \\ [])

  def build_view(type, title, blocks, opts) when is_binary(title) do
    build_view(type, CO.text_object(title), blocks, opts)
  end

  def build_view(type, title, blocks, opts) do
    opts = Utils.convert_text_opts(opts, [:submit, :close])

    %{
      type: type,
      title: title,
      blocks: blocks
    }
    |> Map.merge(Enum.into(opts, %{}))
  end
end
