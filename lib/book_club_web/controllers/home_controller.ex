defmodule BookClubWeb.HomeController do
  use BookClubWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end