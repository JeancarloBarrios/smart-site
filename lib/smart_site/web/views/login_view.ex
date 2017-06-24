defmodule SmartSite.Web.LoginView do
  use SmartSite.Web, :view
  alias SmartSite.Web.LoginView
  alias SmartSite.Web.UserView

  def render("login.json", %{user: user, jwt: jwt, exp: exp})do
    %{
      user: render_one(user, UserView, "user.json"),
      jwt: jwt,
      exp: exp
    }
  end

  def render("logout.json", _params) do
    %{
        message: "Logged Out"
    }
  end

end
