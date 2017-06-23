defmodule SmartSite.Web.Router do
  use SmartSite.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SmartSite.Web do
    pipe_through :api

    # Accounts Ussers URLs
    resources "/users", UserController, except: [:new, :edit]

  end
end
