defmodule PrepagoTest do
  use ExUnit.Case
  doctest Prepago

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

  describe "fazer_chamada/3" do
    test "fazer uma chamada" do
      Assinante.cadastrar("Kang", "123", "123", :prepago)
      Recarga.nova(DateTime.utc_now(), 30, "123")

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 3) ==
        {:ok, "A chamada custou 4.35. Agora você tem 25.65 de créditos"}
    end

    test "fazer uma chamada longa sem ter créditos" do
      Assinante.cadastrar("Kang", "123", "123", :prepago)

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 10) ==
               {:error, "Você não tem créditos para esta ligação. Faça uma recarga."}
    end
  end
end
