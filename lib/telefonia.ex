defmodule Telefonia do
  def start do
    ["pre.txt", "pos.txt"]
    |> Enum.map(fn item -> File.write!(item, :erlang.term_to_binary([])) end)
  end

  def cadastrar_assinante(nome, numero, cpf, plano) do
    Assinante.cadastrar(nome, numero, cpf, plano)
  end

  def listar_assinantes, do: Assinante.assinantes()
  def listar_assinantes_prepago, do: Assinante.assinantes_prepago()
  def listar_assinantes_pospago, do: Assinante.assinantes_pospago()

  def fazer_chamada(numero, plano, data, duracao) do
    case plano  do
      :prepago -> Prepago.fazer_chamada(numero, data, duracao)
      :pospago -> Pospago.fazer_chamada(numero, data, duracao)
    end
  end

  def recarga(data, valor, numero), do: Recarga.nova(data, valor, numero)

  def buscar_por_numero(numero, plano \\ :all), do: Assinante.buscar_assinante(numero, plano)

  def imprimir_contas(mes, ano) do
    Assinante.assinantes_prepago()
    |> Enum.each(fn assinante ->
      assinante = Prepago.imprimir_conta(mes, ano, assinante.numero)
      IO.puts("Conta pré-paga do assinante #{assinante.nome}")
      IO.puts("Número: #{assinante.numero}")
      IO.puts("Chamadas: ")
      IO.inspect(assinante.chamadas)
      IO.puts("Recargas: ")
      IO.inspect(assinante.plano.recargas)
      IO.puts("Total de chamadas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Total de recargas: #{Enum.count(assinante.plano.recargas)}")
      IO.puts("================================================")

      Assinante.assinantes_pospago()
      |> Enum.each(fn assinante ->
      assinante = Pospago.imprimir_conta(mes, ano, assinante.numero)
      IO.puts("Conta pós-paga do assinante #{assinante.nome}")
      IO.puts("Número: #{assinante.numero}")
      IO.puts("Chamadas: ")
      IO.inspect(assinante.chamadas)
      IO.puts("Total de chamadas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Valor da fatura: #{assinante.plano.valor}")
      IO.puts("================================================")
    end)

    end)
  end
end
