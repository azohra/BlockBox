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

  @doc """
  Function that gets a `t:BlockBox.CompositionObjects.option_object` or `t:BlockBox.CompositionObjects.option_group_object` or lists of these objects if indices are provided for group object tuple indices are provided.

  Examples
    iex> BlockBox.Utils.get_initial_opts([options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}], initial_option: 0], :initial_option) 
    [
      options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}],
      initial_option: %{text: "def", value: "hello"}
    ]

    iex> BlockBox.Utils.get_initial_opts([options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}], initial_options: [0,1]], :initial_options) 
    [
      options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}],
      initial_options: [%{text: "abc", value: "world"}, %{text: "def", value: "hello"}]
    ]

    iex> BlockBox.Utils.get_initial_opts([option_groups: [%{label: "yo", options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}]}], initial_option: {0,0}], :initial_option)
    [
      option_groups: [%{label: "yo", options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}]}],
      initial_option: %{text: "def", value: "hello"}
    ]

    iex> BlockBox.Utils.get_initial_opts([option_groups: [%{label: "yo", options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}]}], initial_options: [{0,0}, {0,1}]], :initial_options)
    [
      option_groups: [%{label: "yo", options: [%{text: "def", value: "hello"}, %{text: "abc", value: "world"}]}],
      initial_options: [%{text: "abc", value: "world"}, %{text: "def", value: "hello"}]
    ]

  ## Options
  Options are not included by default.
  """
  @spec get_initial_opts(list(), :initial_option | :initial_options) :: list()
  def get_initial_opts(keyword_opts, type) do
    {_, result} =
      Keyword.get_and_update(keyword_opts, type, fn
        nil ->
          :pop

        val ->
          {val, get_initial_opts_object_type(keyword_opts, val, type)}
      end)

    result
  end

  defp get_initial_opts_object_type(keyword_opts, initial, init_type) do
    opts = Enum.find(keyword_opts, fn {k, _} -> k in [:options, :option_groups] end)

    case opts do
      {opt_type, val} ->
        get_initial_opts_implemented(val, initial, init_type, opt_type)

      nil ->
        initial
    end
  end

  defp get_initial_opts_implemented(opts, indices, type, obj_type) do
    case {type, obj_type} do
      {:initial_option, :options} ->
        Enum.at(opts, indices)

      {:initial_option, :option_groups} ->
        %{options: options, label: _} = Enum.at(opts, elem(indices, 0))
        Enum.at(options, elem(indices, 1))

      {:initial_options, :options} ->
        Enum.with_index(opts)
        |> Enum.reduce([], fn {el, index}, acc ->
          case index in indices do
            true -> [el | acc]
            false -> acc
          end
        end)

      {:initial_options, :option_groups} ->
        index_tups = List.zip(indices)
        first_indices = Tuple.to_list(Enum.at(index_tups, 0))

        Enum.with_index(opts)
        |> Enum.reduce([], fn {el, index_group}, acc_group ->
          %{options: options, label: _} = el

          case index_group in first_indices do
            true ->
              sub_options =
                Enum.with_index(options)
                |> Enum.reduce([], fn {init, index_option}, acc_option ->
                  case {index_group, index_option} in indices do
                    true -> [init | acc_option]
                    false -> acc_option
                  end
                end)

              acc_group ++ sub_options

            false ->
              acc_group
          end
        end)
    end
  end

  def today() do
    {local_date, _hms} = :calendar.local_time()

    local_date
    |> Date.from_erl!()
    |> Date.to_string()
  end
end
