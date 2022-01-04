defmodule Telefonia do
  def start do
    ["pre.txt", "pos.txt"]
    |> Enum.map(fn item -> File.write!(item, :erlang.term_to_binary([])) end)
  end

  def cadastrar_assinante(nome, numero, cpf) do
    Assinante.cadastrar(nome, numero, cpf, :prepago)
  end
end
