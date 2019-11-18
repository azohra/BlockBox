defmodule BlockboxTest do
  use ExUnit.Case
  doctest Blockbox

  test "greets the world" do
    assert Blockbox.hello() == :world
  end
end
