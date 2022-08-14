defmodule DebsTest do
  use ExUnit.Case
  doctest Debs

  test "greets the world" do
    assert Debs.hello() == :world
  end
end
