defmodule SmartSite.Web.LoginController do
  use SmartSite.Web, :controller

  alias SmartSite.Accounts.User

  alias SmartSite.Web.ChangesetView

  action_fallback SmartSite.Web.FallbackController

  def login(conn, params) do
    IO.inspect User.login_changeset(%User{}, params)
    case User.login_changeset(%User{}, params) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        exp = Map.get(claims, "exp")

        new_conn
        |> put_status(200)
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> render("login.json", %{user: user, jwt: jwt, exp: exp})
      {:error, changeset} ->
        conn
        |> put_status(401)
        |> render(ChangesetView, "error.json", %{changeset: changeset})

    end
  end

  def logout(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)
    render("logout.json")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(SmartSite.Web.ErrorView, "401.json")
  end

end
