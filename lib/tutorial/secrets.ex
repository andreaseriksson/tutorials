defmodule Tutorial.Secrets do
  @moduledoc """
  The Secrets context.
  """

  import Ecto.Query, warn: false
  alias Tutorial.Repo

  alias Tutorial.Secrets.Secret

  @doc """
  Returns the list of secrets.

  ## Examples

      iex> list_secrets()
      [%Secret{}, ...]

  """
  def list_secrets(account) do
    from(s in Secret, where: s.account_id == ^account.id, order_by: [asc: :id])
    |> Repo.all()
  end

  @doc """
  Gets a single secret.

  Raises `Ecto.NoResultsError` if the Secret does not exist.

  ## Examples

      iex> get_secret!(123)
      %Secret{}

      iex> get_secret!(456)
      ** (Ecto.NoResultsError)

  """
  def get_secret!(account, id), do: Repo.get_by!(Secret, account_id: account.id, id: id)

  @doc """
  Creates a secret.

  ## Examples

      iex> create_secret(account, %{field: value})
      {:ok, %Secret{}}

      iex> create_secret(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_secret(account, attrs \\ %{}) do
    Ecto.build_assoc(account, :secrets)
    |> Secret.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a secret.

  ## Examples

      iex> update_secret(secret, %{field: new_value})
      {:ok, %Secret{}}

      iex> update_secret(secret, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_secret(%Secret{} = secret, attrs) do
    secret
    |> Secret.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a secret.

  ## Examples

      iex> delete_secret(secret)
      {:ok, %Secret{}}

      iex> delete_secret(secret)
      {:error, %Ecto.Changeset{}}

  """
  def delete_secret(%Secret{} = secret) do
    Repo.delete(secret)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking secret changes.

  ## Examples

      iex> change_secret(secret)
      %Ecto.Changeset{source: %Secret{}}

  """
  def change_secret(%Secret{} = secret) do
    Secret.changeset(secret, %{})
  end
end
