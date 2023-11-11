defmodule Bookmark.BookmarksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bookmark.Bookmarks` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        url: "some url"
      })
      |> Bookmark.Bookmarks.create_link()

    link
  end

  @doc """
  Generate a import.
  """
  def import_fixture(attrs \\ %{}) do
    {:ok, import} =
      attrs
      |> Enum.into(%{
        data: "some data",
        type: "some type"
      })
      |> Bookmark.Bookmarks.create_import()

    import
  end
end
