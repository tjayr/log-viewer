defmodule LogViewer.PageController do
  use LogViewer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, _params) do
    json conn, %{"log": "Hello there"}
  end

end
