defmodule SmartSite.Accounts.User do
  use SmartSite.Web, :model


  alias SmartSite.Accounts.User
  alias SmartSite.Repo

  schema "accounts_users" do
    field :email, :string
    field :last_name, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  def from_email(nil), do: { :error, :not_found }

  def from_email(email), do: Repo.get_by(User, email: email)



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
    password = Ecto.Changeset.get_field(changeset, :password)
    user =
      Ecto.Changeset.get_field(changeset, :email)
      |> from_email
    validate_password(user, password, changeset)
  end

  defp validate_password(nil, _, changeset), do: user_incorrect_error changeset

  defp validate_password(user, password, changeset) do
    %User { password_hash: hash} = user
    case valid_password?(password, hash) do
      true ->
        {:ok, user}
      false ->
        password_incorrect_error(changeset)
    end
  end

  def valid_password?(nil, _), do: false

  def valid_password?(_, nil), do: false

  def valid_password?(password, password_hash), do: Comeonin.Bcrypt.checkpw(password, password_hash)

  defp password_incorrect_error(changeset), do: {:error, Ecto.Changeset.add_error(changeset, :password, "incorrect password")}
  defp user_incorrect_error(changeset), do: {:error, Ecto.Changeset.add_error(changeset, :email, "incorrect email")}
end
