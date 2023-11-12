defmodule Bookmark.Imports do
  @moduledoc """
  The Imports context.
  """

  import Ecto.Query, warn: false
  alias Bookmark.Repo

  alias Bookmark.Imports.Import
  alias Bookmark.Bookmarks
  alias Bookmark.Imports.PinboardImportLink

  @doc """
  Returns the list of imports.

  ## Examples

      iex> list_imports()
      [%Import{}, ...]

  """
  def list_imports do
    Repo.all(Import)
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
  def get_import!(id), do: Repo.get!(Import, id)

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

  def convert_pinboard_link(attrs) do
    %PinboardImportLink{}
    |> PinboardImportLink.changeset(attrs)
    |> Ecto.Changeset.apply_action(:update)
  end

  def import_link_from_pinboard(pinboard_link \\ %PinboardImportLink{}) do
    IO.inspect(pinboard_link)
    munged_attrs = Map.new(Map.from_struct(pinboard_link), fn attr -> 
      case attr do
        {:description, title} -> {:title, title}
        {:href, url} -> {:url, url}
        {:extended, description} -> {:description, description}
        {:time, time} -> {:created_at, time}
        pair -> pair
      end
    end)

    Bookmarks.create_link(munged_attrs)
  end
end
