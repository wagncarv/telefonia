defmodule ContasTes do
  use ExUnit.Case
  doctest Contas

  setup do
    ["pre.txt", "pos.txt"]
    |> Enum.map(fn item ->
      File.write!(item, :erlang.term_to_binary([]))
    end)

    on_exit(fn ->
      ["pos.txt", "pre.txt"]
      |> Enum.map(&File.rm!/1)
    end)
  end
end
