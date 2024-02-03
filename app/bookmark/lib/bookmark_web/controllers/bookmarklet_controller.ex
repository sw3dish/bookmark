defmodule BookmarkWeb.BookmarkletController do
  use BookmarkWeb, :controller

  alias Bookmark.Bookmarks
  alias Bookmark.Bookmarks.Link

  def new(conn, params) do
    changeset = Bookmarks.change_link(%Link{
      url: params["url"],
      title: params["title"],
      description: params["description"],
      to_read: true
    })
    conn = Phoenix.Controller.put_layout(conn, false)
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"link" => link_params}) do
    case Bookmarks.create_link(link_params) do
      {:ok, link} ->
        conn
        |> redirect(to: ~p"/bookmarklet/confirm")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn = Phoenix.Controller.put_layout(conn, false)
        render(conn, :new, changeset: changeset)
    end
  end

  def confirm(conn, _params) do
    conn = Phoenix.Controller.put_layout(conn, false)
    render(conn, :confirm)
  end
end
