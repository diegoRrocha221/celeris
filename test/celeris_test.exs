defmodule CelerisTest do
  use ExUnit.Case
  doctest Celeris

  test "greets the world" do
    assert Celeris.hello() == :world
  end
end
