defmodule TutorialWeb.SecretControllerTest do
  use TutorialWeb.ConnCase

  alias Tutorial.Secrets
  alias Tutorial.Repo
  alias Tutorial.Users.User

  @create_attrs %{key: "some key", value: "some value"}
  @update_attrs %{key: "some updated key", value: "some updated value"}
  @invalid_attrs %{key: nil, value: nil}

  defp login(%{conn: conn}) do
    user = create_user()
    conn = Pow.Plug.assign_current_user(conn, user, otp_app: :mail_flow_admin)

    {:ok, conn: conn}
  end

  defp create_user do
    user_attrs = %{account_name: "Acme Corp", email: "john.doe@example.com", password: "SuperSecret123", password_confirmation: "SuperSecret123"}

    {:ok, user} = User.changeset(%User{}, user_attrs)
                  |> Repo.insert()

    user
    |> Tutorial.Repo.preload(:account)
  end

  defp create_secret(%{conn: conn}) do
    {:ok, secret} =
      case conn.assigns do
        %{current_user: %{account: account}} -> Secrets.create_secret(account, @create_attrs)
        _ ->
          another_account = create_user().account
          Secrets.create_secret(another_account, @create_attrs)
      end

    {:ok, secret: secret}
  end

  describe "index as not logged in" do
    test "redirects to login", %{conn: conn} do
      conn = get(conn, Routes.secret_path(conn, :index))
      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "index" do
    setup [:login]

    test "lists all secrets", %{conn: conn} do
      conn = get(conn, Routes.secret_path(conn, :index))
      assert html_response(conn, 200) =~ "Secrets"
    end
  end

  describe "new secret as not logged in" do
    test "redirects to login", %{conn: conn} do
      conn = get(conn, Routes.secret_path(conn, :new))
      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "new secret" do
    setup [:login]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.secret_path(conn, :new))
      assert html_response(conn, 200) =~ "New Secret"
    end
  end

  describe "create secret as not logged in" do
    test "redirects to login", %{conn: conn} do
      conn = post(conn, Routes.secret_path(conn, :create), secret: @create_attrs)
      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "create secret" do
    setup [:login]

    test "redirects to show when data is valid", %{conn: conn} do
      response = post(conn, Routes.secret_path(conn, :create), secret: @create_attrs)

      assert %{id: id} = redirected_params(response)
      assert redirected_to(response) == Routes.secret_path(response, :show, id)

      conn = get(conn, Routes.secret_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Secret"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.secret_path(conn, :create), secret: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Secret"
    end
  end

  describe "edit secret as not logged in" do
    setup [:create_secret]

    test "redirects to login", %{conn: conn, secret: secret} do
      conn = get(conn, Routes.secret_path(conn, :edit, secret))
      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "edit secret" do
    setup [:login, :create_secret]

    test "renders form for editing chosen secret", %{conn: conn, secret: secret} do
      conn = get(conn, Routes.secret_path(conn, :edit, secret))
      assert html_response(conn, 200) =~ "Edit Secret"
    end
  end

  describe "update secret as not logged in" do
    setup [:create_secret]

    test "redirects to login", %{conn: conn, secret: secret} do
      conn = put(conn, Routes.secret_path(conn, :update, secret), secret: @update_attrs)
      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "update secret" do
    setup [:login, :create_secret]

    test "redirects when data is valid", %{conn: conn, secret: secret} do
      response = put(conn, Routes.secret_path(conn, :update, secret), secret: @update_attrs)
      assert redirected_to(response) == Routes.secret_path(response, :show, secret)

      conn = get(conn, Routes.secret_path(conn, :show, secret))
      assert html_response(conn, 200) =~ "some updated key"
    end

    test "renders errors when data is invalid", %{conn: conn, secret: secret} do
      conn = put(conn, Routes.secret_path(conn, :update, secret), secret: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Secret"
    end
  end

  describe "delete secret as not logged in" do
    setup [:create_secret]

    test "redirects to login", %{conn: conn, secret: secret} do
      conn = delete(conn, Routes.secret_path(conn, :delete, secret))
      assert redirected_to(conn) =~ Routes.pow_session_path(conn, :new)
    end
  end

  describe "delete secret" do
    setup [:login, :create_secret]

    test "deletes chosen secret", %{conn: conn, secret: secret} do
      response = delete(conn, Routes.secret_path(conn, :delete, secret))
      assert redirected_to(response) == Routes.secret_path(response, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.secret_path(conn, :show, secret))
      end
    end
  end

  #
  # describe "index" do
  #   test "lists all secrets", %{conn: conn} do
  #     conn = get(conn, Routes.secret_path(conn, :index))
  #     assert html_response(conn, 200) =~ "Listing Secrets"
  #   end
  # end
  #
  # describe "new secret" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.secret_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Secret"
  #   end
  # end
  #
  # describe "create secret" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.secret_path(conn, :create), secret: @create_attrs)
  #
  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.secret_path(conn, :show, id)
  #
  #     conn = get(conn, Routes.secret_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Show Secret"
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.secret_path(conn, :create), secret: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "New Secret"
  #   end
  # end
  #
  # describe "edit secret" do
  #   setup [:create_secret]
  #
  #   test "renders form for editing chosen secret", %{conn: conn, secret: secret} do
  #     conn = get(conn, Routes.secret_path(conn, :edit, secret))
  #     assert html_response(conn, 200) =~ "Edit Secret"
  #   end
  # end
  #
  # describe "update secret" do
  #   setup [:create_secret]
  #
  #   test "redirects when data is valid", %{conn: conn, secret: secret} do
  #     conn = put(conn, Routes.secret_path(conn, :update, secret), secret: @update_attrs)
  #     assert redirected_to(conn) == Routes.secret_path(conn, :show, secret)
  #
  #     conn = get(conn, Routes.secret_path(conn, :show, secret))
  #     assert html_response(conn, 200) =~ "some updated key"
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn, secret: secret} do
  #     conn = put(conn, Routes.secret_path(conn, :update, secret), secret: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "Edit Secret"
  #   end
  # end
  #
  # describe "delete secret" do
  #   setup [:create_secret]
  #
  #   test "deletes chosen secret", %{conn: conn, secret: secret} do
  #     conn = delete(conn, Routes.secret_path(conn, :delete, secret))
  #     assert redirected_to(conn) == Routes.secret_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.secret_path(conn, :show, secret))
  #     end
  #   end
  # end
end
