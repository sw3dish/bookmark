defmodule BookmarkWeb.ImportController do
  use BookmarkWeb, :controller

  alias Bookmark.Bookmarks
  alias Bookmark.Bookmarks.Import

  def index(conn, _params) do
    imports = Bookmarks.list_imports()
    render(conn, :index, imports: imports)
  end

  def new(conn, _params) do
    changeset = Bookmarks.change_import(%Import{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"import" => import_params}) do
    case import_params do
      %{"export" => %Plug.Upload{content_type: "application/json", path: path}} -> 
        export_contents = File.read!(path)
        links_to_import = Jason.decode!(export_contents)
        IO.inspect(links_to_import)
    end
    render(conn)
    # case Bookmarks.create_import(import_params) do
    #   {:ok, import} ->
    #     conn
    #     |> put_flash(:info, "Import created successfully.")
    #     |> redirect(to: ~p"/imports/#{import}")

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, :new, changeset: changeset)
    # end
  end

  def show(conn, %{"id" => id}) do
    import = Bookmarks.get_import!(id)
    render(conn, :show, import: import)
  end

  def edit(conn, %{"id" => id}) do
    import = Bookmarks.get_import!(id)
    changeset = Bookmarks.change_import(import)
    render(conn, :edit, import: import, changeset: changeset)
  end

  def update(conn, %{"id" => id, "import" => import_params}) do
    import = Bookmarks.get_import!(id)

    case Bookmarks.update_import(import, import_params) do
      {:ok, import} ->
        conn
        |> put_flash(:info, "Import updated successfully.")
        |> redirect(to: ~p"/imports/#{import}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, import: import, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    import = Bookmarks.get_import!(id)
    {:ok, _import} = Bookmarks.delete_import(import)

    conn
    |> put_flash(:info, "Import deleted successfully.")
    |> redirect(to: ~p"/imports")
  end
end
