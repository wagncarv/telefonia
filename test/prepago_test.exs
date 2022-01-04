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
      {:ok, _} = Recarga.nova(DateTime.utc_now(), 30, "123")

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 3) ==
               {:ok, "A chamada custou 4.35. Agora você tem 25.65 de créditos"}
    end

    test "fazer uma chamada longa sem ter créditos" do
      Assinante.cadastrar("Kang", "123", "123", :prepago)

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 10) ==
               {:error, "Você não tem créditos para esta ligação. Faça uma recarga."}
    end
  end

  describe "%Prepago{}" do
    test "retorna estrutura recarga" do
      assert %Prepago{creditos: 10, recargas: []}.creditos == 10
    end
  end

  describe "" do
    test "deve informar valores da conta do mês" do
      Assinante.cadastrar("Kang", "123", "123", :prepago)
      data = DateTime.utc_now()
      data_antiga = ~U[2021-12-04 19:05:31.761146Z]
      Recarga.nova(data, 10, "123")
      Prepago.fazer_chamada("123", data, 3)
      Recarga.nova(data_antiga, 10, "123")
      Prepago.fazer_chamada("123", data_antiga, 3)

      assinante = Assinante.buscar_assinante("123", :prepago)
      assert Enum.count(assinante.chamadas) == 2
      assert Enum.count(assinante.plano.recargas) == 2
      assinante = Prepago.imprimir_conta(data.month, data.year, "123")

      assert assinante.numero == "123"
      assert Enum.count(assinante.chamadas) == 1
      assert Enum.count(assinante.plano.recargas) == 1
    end
  end
end
