defmodule BookmarkWeb.LinkController do
  use BookmarkWeb, :controller

  alias Bookmark.Bookmarks
  alias Bookmark.Bookmarks.Link

  def index(conn, params) do
    current_user = conn.assigns.current_user
    before = Map.get(params, "before")
    aftr = Map.get(params, "after")

    %{entries: entries, metadata: metadata} =
      Bookmarks.list_links(current_user, before: before, after: aftr)

    render(conn, :index, links: entries, page: metadata)
  end

  def favorites(conn, params) do
    current_user = conn.assigns.current_user
    before = Map.get(params, "before")
    aftr = Map.get(params, "after")

    %{entries: entries, metadata: metadata} =
      Bookmarks.list_favorites(current_user, before: before, after: aftr)

    render(conn, :index, links: entries, page: metadata)
  end

  def to_read(conn, params) do
    current_user = conn.assigns.current_user
    before = Map.get(params, "before")
    aftr = Map.get(params, "after")

    %{entries: entries, metadata: metadata} =
      Bookmarks.list_to_read(current_user, before: before, after: aftr)

    render(conn, :index, links: entries, page: metadata)
  end

  def new(conn, _params) do
    changeset = Bookmarks.change_link(%Link{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"link" => link_params}) do
    current_user = conn.assigns.current_user
    link_params = Map.put(link_params, "user_id", current_user.id)

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
    current_user = conn.assigns.current_user
    link = Bookmarks.get_link!(id, current_user)
    render(conn, :show, link: link)
  end

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    link = Bookmarks.get_link!(id, current_user)
    changeset = Bookmarks.change_link(link)
    render(conn, :edit, link: link, changeset: changeset)
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    current_user = conn.assigns.current_user
    link = Bookmarks.get_link!(id, current_user)

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
    current_user = conn.assigns.current_user
    link = Bookmarks.get_link!(id, current_user)
    {:ok, _link} = Bookmarks.delete_link(link)

    conn
    |> put_flash(:info, "Link deleted successfully.")
    |> redirect(to: ~p"/")
  end
end
