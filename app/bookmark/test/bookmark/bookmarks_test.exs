defmodule Bookmark.BookmarksTest do
  use Bookmark.DataCase

  alias Bookmark.Bookmarks

  describe "links" do
    alias Bookmark.Bookmarks.Link

    import Bookmark.BookmarksFixtures

    @invalid_attrs %{description: nil, title: nil, url: nil}

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Bookmarks.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Bookmarks.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{description: "some description", title: "some title", url: "some url"}

      assert {:ok, %Link{} = link} = Bookmarks.create_link(valid_attrs)
      assert link.description == "some description"
      assert link.title == "some title"
      assert link.url == "some url"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookmarks.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()

      update_attrs = %{
        description: "some updated description",
        title: "some updated title",
        url: "some updated url"
      }

      assert {:ok, %Link{} = link} = Bookmarks.update_link(link, update_attrs)
      assert link.description == "some updated description"
      assert link.title == "some updated title"
      assert link.url == "some updated url"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Bookmarks.update_link(link, @invalid_attrs)
      assert link == Bookmarks.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Bookmarks.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Bookmarks.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Bookmarks.change_link(link)
    end
  end

  describe "imports" do
    alias Bookmark.Bookmarks.Import

    import Bookmark.BookmarksFixtures

    @invalid_attrs %{data: nil, type: nil}

    test "list_imports/0 returns all imports" do
      import = import_fixture()
      assert Bookmarks.list_imports() == [import]
    end

    test "get_import!/1 returns the import with given id" do
      import = import_fixture()
      assert Bookmarks.get_import!(import.id) == import
    end

    test "create_import/1 with valid data creates a import" do
      valid_attrs = %{data: "some data", type: "some type"}

      assert {:ok, %Import{} = import} = Bookmarks.create_import(valid_attrs)
      assert import.data == "some data"
      assert import.type == "some type"
    end

    test "create_import/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookmarks.create_import(@invalid_attrs)
    end

    test "update_import/2 with valid data updates the import" do
      import = import_fixture()
      update_attrs = %{data: "some updated data", type: "some updated type"}

      assert {:ok, %Import{} = import} = Bookmarks.update_import(import, update_attrs)
      assert import.data == "some updated data"
      assert import.type == "some updated type"
    end

    test "update_import/2 with invalid data returns error changeset" do
      import = import_fixture()
      assert {:error, %Ecto.Changeset{}} = Bookmarks.update_import(import, @invalid_attrs)
      assert import == Bookmarks.get_import!(import.id)
    end

    test "delete_import/1 deletes the import" do
      import = import_fixture()
      assert {:ok, %Import{}} = Bookmarks.delete_import(import)
      assert_raise Ecto.NoResultsError, fn -> Bookmarks.get_import!(import.id) end
    end

    test "change_import/1 returns a import changeset" do
      import = import_fixture()
      assert %Ecto.Changeset{} = Bookmarks.change_import(import)
    end
  end
end
