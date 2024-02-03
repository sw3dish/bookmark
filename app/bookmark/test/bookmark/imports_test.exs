defmodule Bookmark.ImportsTest do
  use Bookmark.DataCase

  alias Bookmark.Imports

  describe "imports" do
    alias Bookmark.Imports.Import

    import Bookmark.ImportsFixtures

    @invalid_attrs %{data: nil, type: nil}

    test "list_imports/0 returns all imports" do
      import = import_fixture()
      assert Imports.list_imports() == [import]
    end

    test "get_import!/1 returns the import with given id" do
      import = import_fixture()
      assert Imports.get_import!(import.id) == import
    end

    test "create_import/1 with valid data creates a import" do
      valid_attrs = %{data: "some data", type: "some type"}

      assert {:ok, %Import{} = import} = Imports.create_import(valid_attrs)
      assert import.data == "some data"
      assert import.type == "some type"
    end

    test "create_import/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Imports.create_import(@invalid_attrs)
    end

    test "update_import/2 with valid data updates the import" do
      import = import_fixture()
      update_attrs = %{data: "some updated data", type: "some updated type"}

      assert {:ok, %Import{} = import} = Imports.update_import(import, update_attrs)
      assert import.data == "some updated data"
      assert import.type == "some updated type"
    end

    test "update_import/2 with invalid data returns error changeset" do
      import = import_fixture()
      assert {:error, %Ecto.Changeset{}} = Imports.update_import(import, @invalid_attrs)
      assert import == Imports.get_import!(import.id)
    end

    test "delete_import/1 deletes the import" do
      import = import_fixture()
      assert {:ok, %Import{}} = Imports.delete_import(import)
      assert_raise Ecto.NoResultsError, fn -> Imports.get_import!(import.id) end
    end

    test "change_import/1 returns a import changeset" do
      import = import_fixture()
      assert %Ecto.Changeset{} = Imports.change_import(import)
    end
  end
end
