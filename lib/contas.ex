defmodule Contas do
  def imprimir(mes, ano, numero, plano) do
    assinante = Assinante.buscar_assinante(numero)
    chamadas_do_mes = busca_elementos_mes(assinante.chamadas, mes, ano)

    cond do
      plano == :prepago ->
        recargas_do_mes = busca_elementos_mes(assinante.plano.recargas, mes, ano)
        plano = %Prepago{assinante.plano | recargas: recargas_do_mes}
        %Assinante{assinante | chamadas: chamadas_do_mes, plano: plano}

      plano == :pospago ->
        %Assinante{assinante | chamadas: chamadas_do_mes}
    end
  end

  defp busca_elementos_mes(elementos, mes, ano) do
    elementos
    |> Enum.filter(&(&1.data.year == ano && &1.data.month == mes))
  end
end
