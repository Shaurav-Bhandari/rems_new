defmodule BinduBackendWeb.PageController do
  use BinduBackendWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
