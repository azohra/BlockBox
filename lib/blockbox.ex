defmodule BlockBox do
  @moduledoc """
  A tool used to generate slack UI blocks using elixir defined functions.

  ## Installation
  ```elixir
  def deps do
    [
      {:blockbox, "~> 1.1.2"}
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
  A quality-of-life function that takes in the `values` key of the view response payload and generates a map from `action_id` to the bottom level values.

  By default, the function maps `action_id`s to values (recommended approach) but by specifying `:block_id` as the second argument, it will map `block_id`s to values instead.

  ## Example
  ```
    iex> view_values_payload = %{
    ...>  "attachments" => %{
    ...>   "att_input" => %{
    ...>      "type" => "multi_static_select",
    ...>      "selected_options" => [%{"value" => "1"}, %{"value" => "2"}]
    ...>    }
    ...>  },
    ...>  "description" => %{
    ...>    "desc_input" => %{"type" => "plain_text_input", "value" => "description text"}
    ...>  },
    ...>  "labels" => %{
    ...>    "label_input" => %{"type" => "plain_text_input", "value" => "label text"}
    ...>  },
    ...>  "priority" => %{
    ...>    "pri_input" => %{
    ...>      "selected_option" => %{
    ...>        "text" => %{"emoji" => true, "text" => "P4", "type" => "plain_text"},
    ...>        "value" => "9"
    ...>      },
    ...>      "type" => "static_select"
    ...>    }
    ...>  },
    ...>  "summary" => %{
    ...>    "summ_input" => %{"type" => "plain_text_input", "value" => "summary text"}
    ...>  },
    ...>  "watchers" => %{
    ...>    "watch_input" => %{"type" => "multi_users_select", "selected_users" => ["11221", "12D123"]}
    ...>  }
    ...>}
    iex> BlockBox.get_submission_values(view_values_payload)
    %{
      "att_input" => ["1", "2"],
      "desc_input" => "description text",
      "label_input" => "label text",
      "pri_input" => "9",
      "summ_input" => "summary text",
      "watch_input" => ["11221", "12D123"]
    }
    iex> BlockBox.get_submission_values(view_values_payload, :block_id)
    %{
      "attachments" => ["1", "2"],
      "description" => "description text",
      "labels" => "label text",
      "priority" => "9",
      "summary" => "summary text",
      "watchers" => ["11221", "12D123"]
    }
    ```
  """
  @spec get_submission_values(map(), :action_id | :block_id) :: map()
  def get_submission_values(values_payload, type \\ :action_id)

  def get_submission_values(values_payload, :action_id) do
    Enum.reduce(values_payload, %{}, fn {_k, v}, acc ->
      Map.merge(acc, map_values(v))
    end)
  end

  def get_submission_values(values_payload, :block_id) do
    map_values(values_payload)
  end

  defp map_values(payload) do
    Enum.reduce(payload, %{}, fn {k, v}, acc ->
      result = get_val(v)

      case result do
        [head | []] -> Map.put(acc, k, head)
        [_head | _tail] -> Map.put(acc, k, result)
        [] -> acc
        _ -> acc
      end
    end)
  end

  defp get_val(list_val) when is_list(list_val) do
    Enum.reduce(list_val, [], fn v, acc ->
      result_val = get_val(v)

      case result_val do
        nil -> acc
        _ -> acc ++ get_val(v)
      end
    end)
  end

  defp get_val(map_val) when is_map(map_val) do
    val = Map.get(map_val, "value", false)

    val =
      case val do
        false -> Map.get(map_val, "selected_date", false)
        _ -> val
      end

    val =
      case val do
        false -> Map.get(map_val, "selected_date_time", false)
        _ -> val
      end

    val =
      case val do
        false -> Map.get(map_val, "selected_users", false)
        _ -> val
      end

    val =
      case val do
        false -> Map.get(map_val, "selected_channel", false)
        _ -> val
      end

    case val do
      false ->
        Enum.reduce(map_val, [], fn {_k, v}, acc ->
          vals = get_val(v)

          case vals == [] or vals == nil do
            true -> acc
            false -> acc ++ vals
          end
        end)

      _ ->
        [val]
    end
  end

  defp get_val(_val) do
    nil
  end

  defmacro __using__(_opts) do
    quote do
      # composition objects
      defdelegate text_object(text, type \\ :plain_text, opts \\ []), to: CO
      defdelegate confirm_object(title, text, confirm \\ "Confirm", deny \\ "Deny"), to: CO
      defdelegate option_object(text, value, opts \\ []), to: CO
      defdelegate option_group_object(label, options), to: CO
      defdelegate filter_object(options), to: CO

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
      defdelegate checkboxes(action_id, options, opts \\ []), to: BE
      defdelegate select_menu(placeholder, type, action_id, opts \\ []), to: BE
      defdelegate multi_select_menu(placeholder, type, action_id, opts \\ []), to: BE

      # view payload
      defdelegate build_view(type, title, blocks, opts \\ []), to: Views

      # auxilliary functions
      defdelegate get_submission_values(payload, type \\ :action_id), to: BlockBox
    end
  end
end
