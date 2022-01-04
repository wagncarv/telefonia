defmodule AssinanteTest do
  use ExUnit.Case
  doctest Assinante

  setup do
    ["pre.txt", "pos.txt"]
    |> Enum.map(fn item -> File.write!(item, :erlang.term_to_binary([])) end)

    on_exit(fn ->
      ["pos.txt", "pre.txt"]
      |> Enum.map(&File.rm!/1)
    end)
  end

  describe "Assinante.cadastrar/4" do
    test "criar conta prepaga" do
      assert Assinante.cadastrar("Kang", "12", "123", :prepago) ==
               {:ok, "Assinante Kang cadastrado com sucesso"}
    end

    test "erro ao tentar cadastrar assinante já cadastrado" do
      Assinante.cadastrar("Pearl", "12", "123", :prepago)

      assert Assinante.cadastrar("Pearl", "12", "123", :prepago) ==
               {:error, "Assinante com este número já cadastrado"}
    end
  end

  describe "Assinante.buscar/2" do
    test "buscar pospago" do
      Assinante.cadastrar("Yuri", "12", "123", :pospago)

      assert Assinante.buscar_assinante("12", :pospago).nome ==
               "Yuri"
    end

    test "buscar prepago" do
      Assinante.cadastrar("Kant", "12", "123", :prepago)

      assert Assinante.buscar_assinante("12", :prepago).nome ==
               "Kant"
    end

    test "struct Assinante" do
      assert %Assinante{cpf: nil, nome: "teste", numero: nil, plano: nil}.nome == "teste"
    end
  end

  describe "deletar/1" do
    test "remove assinante" do
      Assinante.cadastrar("Scipio", "33", "1243", :prepago)
      assert Assinante.deletar("33") == {:ok, "Assinante Scipio removido"}
    end
  end
end
