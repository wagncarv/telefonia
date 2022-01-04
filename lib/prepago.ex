defmodule Prepago do
  defstruct creditos: 10.0, recarga: []
  @preco_minuto 1.45

  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    custo = @preco_minuto * duracao

    cond do
      custo <= assinante.plano.creditos ->
        plano = assinante.plano
        plano = %__MODULE__{plano | creditos: plano.creditos - custo}

        %Assinante{assinante | plano: plano}
        |> Chamada.registrar(data, duracao)

        {:ok, "A chamada custou #{custo}. Agora você tem #{plano.creditos} de créditos"}

      true ->
        {:error, "Você não tem créditos para esta ligação. Faça uma recarga."}
    end
  end
end
