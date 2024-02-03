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
        url: "https://example.com",
        favorite: false,
        to_read: false
      })
      |> Bookmark.Bookmarks.create_link()

    link
  end
end
