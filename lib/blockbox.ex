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


  unsupported: confirm objects
  """

  alias BlockBox.CompositionObjects, as: CO
  alias BlockBox.LayoutBlocks, as: LB

  @type select_menu_type() ::
          :external_select | :users_select | :conversations_select | :channels_select

  @type multi_select_menu_type() ::
          :multi_external_select
          | :multi_users_select
          | :multi_conversations_select
          | :multi_channels_select

  @doc """
    Creates a plain text input block

    ## Options
    Options are not included by default.
    * `:url` - boolean, only availablein overflow menus

    Optional keys ->
      placeholder: CO.text_object()
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

  @spec select_menu(
          select_menu_type() | multi_select_menu_type(),
          CO.text_object(),
          String.t(),
          keyword()
        ) ::
          map()
  def select_menu(type, placeholder, action_id, opts \\ []) do
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
  @spec static_select(CO.text_object(), list(), list()) :: map()
  def static_select(text_object, options, klist \\ []) do
    type = Keyword.get(klist, :type, "static_select")
    initial = Keyword.get(klist, :initial, false)

    result = %{
      type: type,
      placeholder: text_object,
      options: options
    }

    case initial do
      false -> result
      _ -> Map.put(result, "initial_option", Enum.at(options, initial))
    end
  end

  @doc """
    Creates a date block
    ## Options
    Options are not included by default.
    * `:placeholder` - boolean, only availablein overflow menus
    * `:initial_date` - boolean, only availablein overflow menus
    * `:confirm` - boolean, only availablein overflow menus, unsuported

  """
  @spec datepicker(CO.text_object(), String.t()) :: map()
  def datepicker(plain_text_object_placeholder, date)
      when is_map(plain_text_object_placeholder) do
    %{
      type: "datepicker",
      initial_date: date,
      placeholder: plain_text_object_placeholder
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
      # composition objects
      defdelegate text_object(text, type, opts \\ []), to: BlockBox.CO
      defdelegate option_object(text, value, opts \\ []), to: BlockBox.CO
      defdelegate option_group_object(label, options), to: BlockBox.CO

      defdelegate confirm_object(title, text, confirm \\ "Confirm", deny \\ "Deny"),
        to: BlockBox.CO

      # layout blocks
      defdelegate section(text, opts \\ []), to: BlockBox.LB
      defdelegate divider(opts \\ []), to: BlockBox.LB
      defdelegate image_block(image_url, alt_text, opts \\ []), to: BlockBox.LB
      defdelegate actions_block(elements, opts \\ []), to: BlockBox.LB
      defdelegate context_block(elements, opts \\ []), to: BlockBox.LB
      defdelegate input(label, element, opts \\ []), to: BlockBox.LB
      defdelegate file_block(external_id, source \\ "remote", opts \\ []), to: BlockBox.LB

      # do later
      defdelegate plain_text_input(placeholder, multiline), to: BlockBox
      defdelegate multi_select_users(placeholder_text), to: BlockBox
      defdelegate static_select(text, options, klist \\ []), to: BlockBox
      defdelegate datepicker(date, placeholder_text), to: BlockBox
      defdelegate button_block(text, value), to: BlockBox

      # auxilliary functions
      defdelegate get_submission_values(list_maps), to: BlockBox
    end
  end
end
