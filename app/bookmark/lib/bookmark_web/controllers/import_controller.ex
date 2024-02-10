defmodule BookmarkWeb.ImportController do
  use BookmarkWeb, :controller

  alias Bookmark.Imports
  alias Bookmark.ImportTasks
  alias Bookmark.Imports.Import

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    imports = Imports.list_imports(current_user)
    render(conn, :index, imports: imports)
  end

  def new(conn, _params) do
    changeset = Imports.change_import(%Import{})
    render(conn, :new, changeset: changeset)
  end

  def create(
        conn,
        %{
          "import" => %{
            "export" => %Plug.Upload{content_type: content_type, path: path}
          }
        } = import_params
      ) when content_type in ["application/json", "text/html"] do
    export_contents = File.read!(path)
    import_params = Kernel.put_in(import_params, ["import", "data"], export_contents)
    {_export, import_params} = Kernel.pop_in(import_params, ["import", "export"])
    create(conn, import_params)
  end

  def create(conn, %{"import" => import_params}) do
    current_user = conn.assigns.current_user
    import_params = Map.put(import_params, "user_id", current_user.id)

    case Imports.create_import(import_params) do
      {:ok, %Import{
        type: :pinboard
      } = import} ->
        ImportTasks.import_links_from_pinboard(import.id, import.data, current_user)

        conn
        |> put_flash(:info, "Import started")
        |> redirect(to: ~p"/imports/#{import}")

      {:ok, %Import{
        type: :chrome
      } = import} ->
        ImportTasks.import_links_from_chrome(import.id, import.data, current_user)

        conn
        |> put_flash(:info, "Import started")
        |> redirect(to: ~p"/imports/#{import}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    import = Imports.get_import!(id, current_user)
    render(conn, :show, import: import)
  end

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    import = Imports.get_import!(id, current_user)
    changeset = Imports.change_import(import)
    render(conn, :edit, import: import, changeset: changeset)
  end

  def update(conn, %{"id" => id, "import" => import_params}) do
    current_user = conn.assigns.current_user
    import = Imports.get_import!(id, current_user)

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
    current_user = conn.assigns.current_user
    import = Imports.get_import!(id, current_user)
    {:ok, _import} = Imports.delete_import(import)

    conn
    |> put_flash(:info, "Import deleted successfully.")
    |> redirect(to: ~p"/imports")
  end
end
