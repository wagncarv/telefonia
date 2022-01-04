defmodule Chamada do
  defstruct data: nil, duracao: 0.0

  alias Assinante

  def registrar(assinante, data, duracao) do
    assinante_atualizado = %Assinante{
      assinante
      | chamadas: assinante.chamadas ++ [%__MODULE__{data: data, duracao: duracao}]
    }

    Assinante.atualizar(assinante.numero, assinante_atualizado)
  end
end
