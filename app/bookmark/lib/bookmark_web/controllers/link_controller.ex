defmodule BookmarkWeb.LinkController do
  use BookmarkWeb, :controller

  alias Bookmark.Bookmarks
  alias Bookmark.Bookmarks.Link

  def index(conn, _params) do
    links = Bookmarks.list_links()
    render(conn, :index, links: links)
  end

  def new(conn, params) do
    changeset = Bookmarks.change_link(%Link{
      url: params["url"],
      title: params["title"],
      description: params["description"]
    })
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"link" => link_params}) do
    case Bookmarks.create_link(link_params) do
      {:ok, link} ->
        conn
        |> put_flash(:info, "Link created successfully.")
        |> redirect(to: ~p"/links/#{link}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    link = Bookmarks.get_link!(id)
    render(conn, :show, link: link)
  end

  def edit(conn, %{"id" => id}) do
    link = Bookmarks.get_link!(id)
    changeset = Bookmarks.change_link(link)
    render(conn, :edit, link: link, changeset: changeset)
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    link = Bookmarks.get_link!(id)

    case Bookmarks.update_link(link, link_params) do
      {:ok, link} ->
        conn
        |> put_flash(:info, "Link updated successfully.")
        |> redirect(to: ~p"/links/#{link}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, link: link, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    link = Bookmarks.get_link!(id)
    {:ok, _link} = Bookmarks.delete_link(link)

    conn
    |> put_flash(:info, "Link deleted successfully.")
    |> redirect(to: ~p"/")
  end
end
