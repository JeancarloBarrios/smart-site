# defmodule SmartSite.GuardianAuth do
#
#
#   def login(conn, params) do
#     case User.find_and_confirm_password(params) do
#       {:ok, user} ->
#         new_conn = Guardian.Plug.api_sign_in(conn, user)
#         jwt = Guardian.Plug.current_token(new_conn)
#         claims = Guardian.Plug.claims(new_conn)
#         exp = Map.get(claims, "exp")
#
#         new_conn
#           |> put_resp_header("authorization", "Bearer #{jwt}")
#           |> put_resp_header("x-expires", exp)
#           |> render "login.json", user: user, jwt: jwt, exp: exp
#       {}
#
#     end
#   end
#
# end