defmodule BookmarkWeb.Api.LinkController do
  use BookmarkWeb, :controller

  alias Bookmark.Bookmarks
  alias Bookmark.Bookmarks.Link

  action_fallback BookmarkWeb.FallbackController

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    links = Bookmarks.list_links(current_user)
    render(conn, :index, links: links)
  end

  def create(conn, %{"link" => link_params}) do
    current_user = conn.assigns.current_user
    link_params = Map.put(link_params, "user_id", current_user.id)

    with {:ok, %Link{} = link} <- Bookmarks.create_link(link_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/links/#{link}")
      |> render(:show, link: link)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    link = Bookmarks.get_link!(id, current_user)
    render(conn, :show, link: link)
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    current_user = conn.assigns.current_user
    link = Bookmarks.get_link!(id, current_user)

    with {:ok, %Link{} = link} <- Bookmarks.update_link(link, link_params) do
      render(conn, :show, link: link)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    link = Bookmarks.get_link!(id, current_user)

    with {:ok, %Link{}} <- Bookmarks.delete_link(link) do
      send_resp(conn, :no_content, "")
    end
  end
end
