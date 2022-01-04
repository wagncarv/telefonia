defmodule Assinante do
  @moduledoc """
   Módulo de assinante para cadastro de assinantes como `prepago` e `pospago`.
   A função mais utilizada é a `cadastrar/4`
  """
  defstruct nome: nil, numero: nil, cpf: nil, plano: nil, chamadas: []

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)

  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)
  defp buscar(numero, :all), do: filtro(assinantes(), numero)

  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  defp assinantes_prepago, do: read(:prepago)
  defp assinantes_pospago, do: read(:pospago)
  defp assinantes, do: read(:prepago) ++ read(:pospago)

  @doc """
  Realiza o cadastro de assinante `prepago` ou `pospago`.

  ## Parâmetros da função

  - nome: nome do assinante
  - numero: número único. Caso exista, pode retornar um erro.
  - cpf: documento CPF do assinante.
  - plano: parâmetro opcional. Plano de assinatura, que pode ser `:prepago` ou `:pospago`. Caso não seja fornecido, `:prepago` é usado como padrão.

  ## Erros

  `{:error, "Assinante com este número já cadastrado"}` = Caso número já exista, retorna este erro.

  ## Exemplo

        iex> Assinante.cadastrar("Hilbert", "19", "123789", :prepago)
        {:ok, "Assinante Hilbert cadastrado com sucesso"}
  """
  def cadastrar(nome, numero, cpf, :prepago), do: cadastrar(nome, numero, cpf, %Prepago{})

  def cadastrar(nome, numero, cpf, :pospago), do: cadastrar(nome, numero, cpf, %Pospago{})

  def cadastrar(nome, numero, cpf, plano) do
    case buscar_assinante(numero) do
      nil ->
        assinante = %__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}

        (read(pegar_plano(assinante)) ++ [assinante])
        |> :erlang.term_to_binary()
        |> write(pegar_plano(assinante))

        {:ok, "Assinante #{nome} cadastrado com sucesso"}

      _assinante ->
        {:error, "Assinante com este número já cadastrado"}
    end
  end

  def atualizar(numero, assinante) do
    {assinante_antigo, nova_lista} = deletar_item(numero)

    case assinante.plano.__struct__ == assinante_antigo.plano.__struct__ do
      true ->
        (nova_lista ++ [assinante])
        |> :erlang.term_to_binary()
        |> write(pegar_plano(assinante))

      false ->
        {:erro, "Assinante não pode alterar o plano"}
    end
  end

  defp pegar_plano(assinante) do
    case assinante.plano.__struct__ == Prepago do
      true -> :prepago
      false -> :pospago
    end
  end

  defp write(lista_assinantes, plano) do
    File.write(@assinantes[plano], lista_assinantes)
  end

  def deletar(numero) do
    {assinante, nova_lista} = deletar_item(numero)

    nova_lista
    |> :erlang.term_to_binary()
    |> write(pegar_plano(assinante))

    {:ok, "Assinante #{assinante.nome} removido"}
  end

  def deletar_item(numero) do
    assinante = buscar_assinante(numero)

    nova_lista =
      read(pegar_plano(assinante))
      |> List.delete(assinante)

    {assinante, nova_lista}
  end

  defp read(plano) do
    case read_file(@assinantes[plano]) do
      {:ok, assinantes} -> :erlang.binary_to_term(assinantes)
      {:error, :enoent} -> {:error, "Arquivo inválido"}
    end
  end

  defp read_file(file) do
    case file do
      nil -> {:error, "Invalid file"}
      _ -> File.read(file)
    end
  end
end
