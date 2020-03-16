defmodule TutorialWeb.SecretController do
  use TutorialWeb, :controller

  alias Tutorial.Secrets
  alias Tutorial.Secrets.Secret

  def index(conn, _params) do
    current_account = conn.assigns.current_account
    secrets = Secrets.list_secrets(current_account)
    render(conn, "index.html", secrets: secrets)
  end

  def new(conn, _params) do
    changeset = Secrets.change_secret(%Secret{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"secret" => secret_params}) do
    current_account = conn.assigns.current_account

    case Secrets.create_secret(current_account, secret_params) do
      {:ok, secret} ->
        conn
        |> put_flash(:info, "Secret created successfully.")
        |> redirect(to: Routes.secret_path(conn, :show, secret))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    secret = Secrets.get_secret!(current_account, id)

    render(conn, "show.html", secret: secret)
  end

  def edit(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    secret = Secrets.get_secret!(current_account, id)

    changeset = Secrets.change_secret(secret)
    render(conn, "edit.html", secret: secret, changeset: changeset)
  end

  def update(conn, %{"id" => id, "secret" => secret_params}) do
    current_account = conn.assigns.current_account
    secret = Secrets.get_secret!(current_account, id)


    case Secrets.update_secret(secret, secret_params) do
      {:ok, secret} ->
        conn
        |> put_flash(:info, "Secret updated successfully.")
        |> redirect(to: Routes.secret_path(conn, :show, secret))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", secret: secret, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    secret = Secrets.get_secret!(current_account, id)

    {:ok, _secret} = Secrets.delete_secret(secret)

    conn
    |> put_flash(:info, "Secret deleted successfully.")
    |> redirect(to: Routes.secret_path(conn, :index))
  end
end
