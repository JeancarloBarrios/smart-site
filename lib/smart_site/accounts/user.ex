defmodule SmartSite.Accounts.User do
  use SmartSite.Web, :model


  alias SmartSite.Accounts.User


  schema "accounts_users" do
    field :email, :string
    field :last_name, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  def from_email(nil), do: { :error, :not_found }

  def from_email(email), do: Repo.one(User, email: email)



  @doc false
  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :last_name, :email, :password])
    |> validate_required([:name, :last_name, :email])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_password_hash
  end

  def registration_changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :last_name, :email, :password])
    |> validate_required([:name, :last_name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  def login_changeset(%User{} = user), do: user |> cast(%{}, ~w(email password)a)

  def login_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, ~w(email password)a)
    |> validate_required(~w(email password)a)
    |> validate_password
  end

  defp validate_password(changeset) do
    case Ecto.Changeset.get_field(changeset, :password_hash) do
      nil -> password_incorrect_error(changeset)
      crypted -> validate_password(changeset, crypted)
    end
  end

  defp validate_password(changeset, crypted) do
    password = Ecto.Changeset.get_change(changeset, :password)
    case valid_password?(password, crypted) do
      true ->
        changeset
      false ->
        password_incorrect_error(changeset)
    end
  end

  def valid_password?(nil, _), do: false

  def valid_password?(_, nil), do: false

  def valid_password?(password, crypted), do: Comeonin.Bcrypt.checkpw(password, crypted)

  defp password_incorrect_error(changeset), do: Ecto.Changeset.add_error(changeset, :password, "incorrect password")
end
