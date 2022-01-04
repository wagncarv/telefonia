defmodule ChamadaTest do
    use ExUnit.Case
    doctest Chamada

    setup do
      ["pre.txt", "pos.txt"]
      |> Enum.map(fn item -> File.write!(item, :erlang.term_to_binary([])) end)

      on_exit(fn ->
        ["pos.txt", "pre.txt"]
        |> Enum.map(&File.rm!/1)
      end)
    end

    describe "registrar/3" do
        test "resgitrar chamada" do
            Assinante.cadastrar("Kang", "12", "123", :prepago)
            assinante = Assinante.buscar_assinante("12")
            assert Chamada.registrar(assinante, DateTime.utc_now(), 3) == :ok
        end
    end

    describe "%Chamada{}" do
        test "estrutura chamada" do
            assert %Chamada{data: DateTime.utc_now(), duracao: 3}.duracao == 3
        end
    end
end
