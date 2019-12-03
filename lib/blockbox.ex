defmodule BlockBox do
  @moduledoc """
  A tool used to generate slack UI blocks using elixir defined functions.

  ## Installation
  ```elixir
  def deps do
    [
      {:blockbox, "~> 1.0.0"}
    ]
  end
  ```

  ## Usage
  use BlockBox to access all the generator functions defined in other modules.
  ```elixir
    use BlockBox
  ```
  """

  alias BlockBox.CompositionObjects, as: CO
  alias BlockBox.LayoutBlocks, as: LB
  alias BlockBox.BlockElements, as: BE
  alias BlockBox.Views, as: Views

  @doc """
  A quality-of-life function that parses the view response payload to extract the block_id:block_value key-value pairs
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
      defdelegate text_object(text, type \\ :plain_text, opts \\ []), to: CO
      defdelegate confirm_object(title, text, confirm \\ "Confirm", deny \\ "Deny"), to: CO
      defdelegate option_object(text, value, opts \\ []), to: CO
      defdelegate option_group_object(label, options), to: CO

      # layout blocks
      defdelegate section(text, opts \\ []), to: LB
      defdelegate divider(opts \\ []), to: LB
      defdelegate image_block(image_url, alt_text, opts \\ []), to: LB
      defdelegate actions_block(elements, opts \\ []), to: LB
      defdelegate context_block(elements, opts \\ []), to: LB
      defdelegate input(label, element, opts \\ []), to: LB
      defdelegate file_block(external_id, source \\ "remote", opts \\ []), to: LB

      # block elements
      defdelegate button(text, action_id, opts \\ []), to: BE
      defdelegate datepicker(action_id, opts \\ []), to: BE
      defdelegate image(image_url, alt_text), to: BE
      defdelegate overflow_menu(action_id, options, opts \\ []), to: BE
      defdelegate plain_text_input(action_id, opts \\ []), to: BE
      defdelegate radio_buttons(action_id, options, opts \\ []), to: BE
      defdelegate select_menu(placeholder, type, action_id, opts \\ []), to: BE
      defdelegate multi_select_menu(placeholder, type, action_id, opts \\ []), to: BE

      # view payload
      defdelegate build_view(type, title, blocks, opts \\ []), to: Views

      # auxilliary functions
      defdelegate get_submission_values(list_maps), to: BlockBox
    end
  end
end
