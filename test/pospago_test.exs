defmodule PospagoTest do
  use ExUnit.Case
  doctest Pospago

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
    test "fazer chamada" do
      Assinante.cadastrar("Kang", "123", "123", :pospago)

      assert Pospago.fazer_chamada("123", DateTime.utc_now(), 5) ==
               {:ok, "Chamada realizada com sucesso. Duração: 5 minutos"}
    end
  end

  describe "%Pospago{}" do
    test "retorna estrutura" do
      assert %Pospago{valor: 10}.valor == 10
    end
  end

  describe "imprimir_conta/3" do
      test "imprime chamadas" do
        Assinante.cadastrar("Kang", "123", "123", :pospago)
        data = DateTime.utc_now()
        data_antiga = ~U[2021-12-04 19:05:31.761146Z]
        Pospago.fazer_chamada("123", data, 3)
        Pospago.fazer_chamada("123", data_antiga, 3)
        Pospago.fazer_chamada("123", data, 3)
        Pospago.fazer_chamada("123", data_antiga, 3)

        assinante = Assinante.buscar_assinante("123", :pospago)
        assert Enum.count(assinante.chamadas) == 4
        assinante = Pospago.imprimir_conta(data.month, data.year, "123")

        assert assinante.numero == "123"
        assert Enum.count(assinante.chamadas) == 2
        assert assinante.plano.valor == 8.399999999999999
      end
  end
end
