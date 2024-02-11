defmodule Bookmark.Imports do
  @moduledoc """
  The Imports context.
  """

  import Ecto.Query, warn: false
  alias Bookmark.Repo

  alias Bookmark.Imports.Import
  alias Bookmark.Bookmarks

  @doc """
  Returns the list of imports.

  ## Examples

      iex> list_imports()
      [%Import{}, ...]

  """
  def list_imports(current_user) do
    query =
      from i in Import, where: i.user_id == ^current_user.id, order_by: [desc: i.inserted_at]

    Repo.all(query)
  end

  @doc """
  Gets a single import.

  Raises `Ecto.NoResultsError` if the Import does not exist.

  ## Examples

      iex> get_import!(123)
      %Import{}

      iex> get_import!(456)
      ** (Ecto.NoResultsError)

  """
  def get_import!(id, current_user) do
    query = from i in Import, where: i.user_id == ^current_user.id and i.id == ^id
    Repo.one!(query)
  end

  @doc """
  Creates a import.

  ## Examples

      iex> create_import(%{field: value})
      {:ok, %Import{}}

      iex> create_import(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_import(attrs \\ %{}) do
    %Import{}
    |> Import.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a import.

  ## Examples

      iex> update_import(import, %{field: new_value})
      {:ok, %Import{}}

      iex> update_import(import, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_import(%Import{} = import, attrs) do
    import
    |> Import.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a import.

  ## Examples

      iex> delete_import(import)
      {:ok, %Import{}}

      iex> delete_import(import)
      {:error, %Ecto.Changeset{}}

  """
  def delete_import(%Import{} = import) do
    Repo.delete(import)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking import changes.

  ## Examples

      iex> change_import(import)
      %Ecto.Changeset{data: %Import{}}

  """
  def change_import(%Import{} = import, attrs \\ %{}) do
    Import.changeset(import, attrs)
  end

  alias Bookmark.Imports.PinboardImportLink

  def import_link_from_pinboard(pinboard_link \\ %PinboardImportLink{}, current_user) do
    munged_attrs =
      Map.new(Map.from_struct(pinboard_link), fn attr ->
        case attr do
          {:description, title} -> {:title, title}
          {:href, url} -> {:url, url}
          {:extended, description} -> {:description, description}
          {:time, time} -> {:inserted_at, time}
          {:toread, "yes"} -> {:to_read, true}
          {:toread, "no"} -> {:to_read, false}
          pair -> pair
        end
      end)

    munged_attrs = Map.put(munged_attrs, :user_id, current_user.id)
    Bookmarks.create_link(munged_attrs)
  end

  def create_pinboard_link(attrs) do
    %PinboardImportLink{}
    |> PinboardImportLink.changeset(attrs)
    |> Ecto.Changeset.apply_action(:update)
  end

  alias Bookmark.Imports.ChromeHtmlImportLink

  def load_chrome_html_bookmarks(data) do
    {:ok, html} = Floki.parse_document(data)

    links = Floki.find(html, "a")

    Enum.map(links, fn link ->
      [title] = Floki.children(link)
      [url] = Floki.attribute(link, "a", "href")
      [inserted_at] = Floki.attribute(link, "a", "add_date")

      %{
        title: title,
        url: url,
        inserted_at: Bookmark.ImportHelpers.get_date_from_netscape_date(inserted_at)
      }
    end)
  end

  def import_link_from_chrome_html(chrome_link \\ %PinboardImportLink{}, current_user) do
    link_attrs = Map.from_struct(chrome_link)
    link_attrs = Map.put(link_attrs, :user_id, current_user.id)
    Bookmarks.create_link(link_attrs)
  end

  def create_chrome_html_import_link(attrs) do
    %ChromeHtmlImportLink{}
    |> ChromeHtmlImportLink.changeset(attrs)
    |> Ecto.Changeset.apply_action(:update)
  end
end
