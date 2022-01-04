defmodule RecargaTest do
    use ExUnit.Case
    doctest Recarga

    setup do
        ["pre.txt", "pos.txt"]
        |> Enum.map(fn item -> File.write!(item, :erlang.term_to_binary([])) end)

        on_exit(fn ->
          ["pos.txt", "pre.txt"]
          |> Enum.map(&File.rm!/1)
        end)
    end

    describe "nova/3" do
        test "realizar uma recarga" do
            assinante = Assinante.cadastrar("Kang", "12", "123", :prepago)

            {:ok, msg} = Recarga.nova(DateTime.utc_now(), 30, "12")
            assert msg == "Recarga realizada com sucesso"

            assinante = Assinante.buscar_assinante("12", :prepago)
            assert assinante.plano.creditos == 30
            assert Enum.count(assinante.plano.recargas) == 1
        end
    end

    describe "%Recarga{}" do
        test "retorna estrutura recarga" do
            assert %Recarga{data: DateTime.utc_now(), valor: 10}.valor == 10
        end

    end
end
