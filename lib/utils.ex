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

  def today() do
    {local_date, _hms} = :calendar.local_time()

    local_date
    |> Date.from_erl!()
    |> Date.to_string()
  end
end
