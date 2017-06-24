defmodule SmartSite.Web.Router do
  use SmartSite.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end


  scope "/api/v1", SmartSite.Web do
    pipe_through :api
    # Login Controler
    post "/login", LoginController, :login
    delete "/logout", LoginController, :logout
    # Accounts Ussers URLs
    resources "/users", UserController, except: [:new, :edit]

  end

end
