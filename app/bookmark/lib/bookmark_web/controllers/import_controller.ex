defmodule BookmarkWeb.ImportController do
  use BookmarkWeb, :controller

  alias Bookmark.Imports
  alias Bookmark.ImportTasks
  alias Bookmark.Imports.Import

  def index(conn, _params) do
    imports = Imports.list_imports()
    render(conn, :index, imports: imports)
  end

  def new(conn, _params) do
    changeset = Imports.change_import(%Import{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"import" => import_params}) do
    case import_params do
      %{"export" => %Plug.Upload{content_type: "application/json", path: path}} -> 
        export_contents = File.read!(path)
        ImportTasks.import_links_from_pinboard(1, export_contents)
      %{"data" => data} ->
        ImportTasks.import_links_from_pinboard(1, data)
    end
    case Imports.create_import(import_params) do
      {:ok, import} ->
        conn
        |> put_flash(:info, "Import started")
        |> redirect(to: ~p"/imports/#{import}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    import = Imports.get_import!(id)
    render(conn, :show, import: import)
  end

  def edit(conn, %{"id" => id}) do
    import = Imports.get_import!(id)
    changeset = Imports.change_import(import)
    render(conn, :edit, import: import, changeset: changeset)
  end

  def update(conn, %{"id" => id, "import" => import_params}) do
    import = Imports.get_import!(id)

    case Imports.update_import(import, import_params) do
      {:ok, import} ->
        conn
        |> put_flash(:info, "Import updated successfully.")
        |> redirect(to: ~p"/imports/#{import}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, import: import, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    import = Imports.get_import!(id)
    {:ok, _import} = Imports.delete_import(import)

    conn
    |> put_flash(:info, "Import deleted successfully.")
    |> redirect(to: ~p"/imports")
  end
end
