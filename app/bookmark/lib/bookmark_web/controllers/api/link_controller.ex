defmodule BookmarkWeb.Api.LinkController do
  use BookmarkWeb, :controller

  alias Bookmark.Bookmarks
  alias Bookmark.Bookmarks.Link

  action_fallback BookmarkWeb.FallbackController

  def index(conn, _params) do
    links = Bookmarks.list_links()
    render(conn, :index, links: links)
  end

  def create(conn, %{"link" => link_params}) do
    with {:ok, %Link{} = link} <- Bookmarks.create_link(link_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/api/links/#{link}")
      |> render(:show, link: link)
    end
  end

  def show(conn, %{"id" => id}) do
    link = Bookmarks.get_link!(id)
    render(conn, :show, link: link)
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    link = Bookmarks.get_link!(id)

    with {:ok, %Link{} = link} <- Bookmarks.update_link(link, link_params) do
      render(conn, :show, link: link)
    end
  end

  def delete(conn, %{"id" => id}) do
    link = Bookmarks.get_link!(id)

    with {:ok, %Link{}} <- Bookmarks.delete_link(link) do
      send_resp(conn, :no_content, "")
    end
  end
end
