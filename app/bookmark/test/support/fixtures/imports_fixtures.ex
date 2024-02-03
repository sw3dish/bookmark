defmodule Bookmark.ImportsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bookmark.Imports` context.
  """

  @doc """
  Generate a import.
  """
  def import_fixture(attrs \\ %{}) do
    {:ok, import} =
      attrs
      |> Enum.into(%{
        data: "some data",
        type: :pinboard,
      })
      |> Bookmark.Imports.create_import()

    import
  end
end
