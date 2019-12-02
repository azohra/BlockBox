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

  alias BlockBox.CompositionObjects, as: CO
  alias BlockBox.LayoutBlocks, as: LB
  alias BlockBox.BlockElements, as: BE

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

      # block elements
      defdelegate button(text, action_id, opts \\ []), to: BlockBox.BE
      defdelegate datepicker(action_id, opts \\ []), to: BlockBox.BE
      defdelegate image(image_url, alt_text), to: BlockBox.BE
      defdelegate overflow_menu(action_id, options, opts \\ []), to: BlockBox.BE
      defdelegate plain_text_input(action_id, opts \\ []), to: BlockBox.BE
      defdelegate radio_buttons(action_id, options, opts \\ []), to: BlockBox.BE
      defdelegate select_menu(placeholder, type, action_id, opts \\ []), to: BlockBox.BE
      defdelegate multi_select_menu(placeholder, type, action_id, opts \\ []), to: BlockBox.BE

      # auxilliary functions
      defdelegate get_submission_values(list_maps), to: BlockBox
    end
  end
end
