defmodule SmartSite.Repo.Migrations.CreateSmartSite.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :name, :string
      add :last_name, :string
      add :email, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:accounts_users, ~w(email)a)
  end
end
