defmodule Pospago do
  defstruct valor: nil

  @custo_minuto 1.40

  def fazer_chamada(numero, data, duracao) do
    Assinante.buscar_assinante(numero, :pospago)
    |> Chamada.registrar(data, duracao)

    {:ok, "Chamada realizada com sucesso. Duração: #{duracao} minutos"}
  end

  def imprimir_conta(mes, ano, numero) do
    assinante = Contas.imprimir(mes, ano, numero, :pospago)

    valor_total = assinante.chamadas
    |> Stream.map(&(&1.duracao * @custo_minuto))
    |> Enum.sum()

    %Assinante{assinante | plano: %__MODULE__{valor: valor_total}}
  end
end
