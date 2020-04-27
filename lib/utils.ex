defmodule BlockBox.Utils do
  @moduledoc false

  alias BlockBox.CompositionObjects, as: CO

  @spec convert_text_opts(keyword(), list(atom())) :: keyword()
  def convert_text_opts(opts, text_opts) do
    Enum.map(opts, fn
      {opt, val} ->
        if is_binary(val) and opt in text_opts do
          {opt, CO.text_object(val)}
        else
          {opt, val}
        end
    end)
  end

  def convert_initial_opts(opts) do
    select_key =
      cond do
        Keyword.has_key?(opts, :initial_option) -> :initial_option
        Keyword.has_key?(opts, :initial_options) -> :initial_options
        true -> nil
      end

    case select_key do
      nil ->
        opts

      select_key ->
        opts
        |> Keyword.update(select_key, nil, fn
          x when is_list(x) -> x
          x -> [x]
        end)
        |> convert_initial_opts_helper(select_key)
    end
  end

  defp convert_initial_opts_helper(opts, put_opt) do
    items =
      case Keyword.get(opts, put_opt) do
        [val | _tail] = initials when is_integer(val) ->
          options = Keyword.get(opts, :options)
          Enum.map(initials, fn index -> options |> Enum.at(index) end)

        [val | _tail] = initials when is_tuple(val) ->
          option_groups = Keyword.get(opts, :option_groups)

          Enum.map(initials, fn {grp_ind, opt_ind} ->
            option_groups
            |> Enum.at(grp_ind)
            |> Map.get(:options)
            |> Enum.at(opt_ind)
          end)

        no_processing_required ->
          no_processing_required
      end

    case put_opt do
      :initial_option ->
        Keyword.put(opts, put_opt, hd(items))

      _ ->
        Keyword.put(opts, put_opt, items)
    end
  end

  def today() do
    {local_date, _hms} = :calendar.local_time()

    local_date
    |> Date.from_erl!()
    |> Date.to_string()
  end
end
