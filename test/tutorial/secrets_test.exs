defmodule Tutorial.SecretsTest do
  use Tutorial.DataCase

  alias Tutorial.Secrets

  describe "secrets" do
    alias Tutorial.Secrets.Secret

    @valid_attrs %{key: "some key", value: "some value"}
    @update_attrs %{key: "some updated key", value: "some updated value"}
    @invalid_attrs %{key: nil, value: nil}

    def account_fixture() do
      {:ok, account} = Tutorial.Accounts.create_account(%{name: "Acme Corp"})
      account
    end

    def secret_fixture(account, attrs \\ %{}) do
      {:ok, secret} =
        Secrets.create_secret(
          account,
          Enum.into(attrs, @valid_attrs)
        )

      secret
    end

    setup do
      account = account_fixture()
      secret = secret_fixture(account)
      {:ok, %{account: account, secret: secret}}
    end

    test "list_secrets/0 returns all secrets", %{account: account, secret: secret} do
      assert Secrets.list_secrets(account) == [secret]
    end

    test "get_secret!/1 returns the secret with given id", %{account: account, secret: secret} do
      assert Secrets.get_secret!(account, secret.id) == secret
    end

    test "create_secret/1 with valid data creates a secret", %{account: account} do
      assert {:ok, %Secret{} = secret} = Secrets.create_secret(account, @valid_attrs)
      assert secret.key == "some key"
      assert secret.value == "some value"
    end

    test "create_secret/1 with invalid data returns error changeset", %{account: account} do
      assert {:error, %Ecto.Changeset{}} = Secrets.create_secret(account, @invalid_attrs)
    end

    test "update_secret/2 with valid data updates the secret", %{secret: secret} do
      assert {:ok, %Secret{} = secret} = Secrets.update_secret(secret, @update_attrs)
      assert secret.key == "some updated key"
      assert secret.value == "some updated value"
    end

    test "update_secret/2 with invalid data returns error changeset", %{account: account, secret: secret} do
      assert {:error, %Ecto.Changeset{}} = Secrets.update_secret(secret, @invalid_attrs)
      assert secret == Secrets.get_secret!(account, secret.id)
    end

    test "delete_secret/1 deletes the secret", %{account: account, secret: secret} do
      assert {:ok, %Secret{}} = Secrets.delete_secret(secret)
      assert_raise Ecto.NoResultsError, fn -> Secrets.get_secret!(account, secret.id) end
    end

    test "change_secret/1 returns a secret changeset", %{secret: secret} do
      assert %Ecto.Changeset{} = Secrets.change_secret(secret)
    end
  end
end
