defmodule Bookmark.ImportsTest do
  use Bookmark.DataCase

  alias Bookmark.Imports

  describe "imports" do
    alias Bookmark.Imports.Import
    import Bookmark.AccountsFixtures
    import Bookmark.ImportsFixtures

    @invalid_attrs %{data: nil, type: nil}
    @invalid_status_attrs %{
      data: "some data",
      type: :pinboard,
      status: :invalid
    }

    @invalid_type_attrs %{
      data: "some data",
      type: :invalid
    }

    test "list_imports/0 returns all imports" do
      user_1 = user_fixture()
      user_2 = user_fixture()
      import_1 = import_fixture(%{user_id: user_1.id})
      _import_2 = import_fixture(%{user_id: user_2.id})
      assert Imports.list_imports(user_1) == [import_1]
    end

    test "get_import!/2 returns the import with given id for the given user" do
      user = user_fixture()
      import = import_fixture(%{user_id: user.id})
      assert Imports.get_import!(import.id, user) == import
    end

    test "get_import!/2 raises an error when a user is passed that didn't create it" do
      user_1 = user_fixture()
      user_2 = user_fixture()
      import = import_fixture(%{user_id: user_1.id})

      assert_raise Ecto.NoResultsError, fn ->
        Imports.get_import!(import.id, user_2)
      end
    end

    test "create_import/1 with valid data creates a import" do
      user = user_fixture()

      valid_attrs = %{
        data: "some data",
        type: :pinboard,
        user_id: user.id
      }

      assert {:ok, %Import{} = import} = Imports.create_import(valid_attrs)
      assert import.data == "some data"
      assert import.type == :pinboard
      assert import.user_id == user.id
    end

    test "create_import/1 with invalid status returns error changeset" do
      user = user_fixture()
      invalid_status_attrs = Map.put(@invalid_status_attrs, :user_id, user.id)
      assert {:error, %Ecto.Changeset{}} = Imports.create_import(invalid_status_attrs)
    end

    test "create_import/1 with invalid type returns error changeset" do
      user = user_fixture()
      invalid_type_attrs = Map.put(@invalid_type_attrs, :user_id, user.id)
      assert {:error, %Ecto.Changeset{}} = Imports.create_import(invalid_type_attrs)
    end

    test "create_import/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Imports.create_import(@invalid_attrs)
    end

    test "update_import/2 with valid data updates the import" do
      user = user_fixture()
      import = import_fixture(%{user_id: user.id})

      update_attrs = %{
        data: "some updated data",
        type: :chrome,
        status: :completed,
        count: 1,
        completed_at: ~U[2024-02-03 21:12:59Z]
      }

      assert {:ok, %Import{} = import} = Imports.update_import(import, update_attrs)
      assert import.data == "some updated data"
      assert import.type == :chrome
      assert import.status == :completed
      assert import.user_id == user.id
      assert import.count == 1
      assert import.completed_at == ~U[2024-02-03 21:12:59Z]
    end

    test "update_import/2 with invalid status returns error changeset" do
      user = user_fixture()
      import = import_fixture(%{user_id: user.id})
      invalid_status_attrs = Map.put(@invalid_status_attrs, :user_id, user.id)
      assert {:error, %Ecto.Changeset{}} = Imports.update_import(import, invalid_status_attrs)
      assert import == Imports.get_import!(import.id, user)
    end

    test "update_import/2 with invalid type returns error changeset" do
      user = user_fixture()
      import = import_fixture(%{user_id: user.id})
      invalid_type_attrs = Map.put(@invalid_type_attrs, :user_id, user.id)
      assert {:error, %Ecto.Changeset{}} = Imports.update_import(import, invalid_type_attrs)
      assert import == Imports.get_import!(import.id, user)
    end

    test "update_import/2 with invalid data returns error changeset" do
      user = user_fixture()
      import = import_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Imports.update_import(import, @invalid_attrs)
      assert import == Imports.get_import!(import.id, user)
    end

    test "delete_import/1 deletes the import" do
      user = user_fixture()
      import = import_fixture(%{user_id: user.id})
      assert {:ok, %Import{}} = Imports.delete_import(import)
      assert_raise Ecto.NoResultsError, fn -> Imports.get_import!(import.id, user) end
    end

    test "change_import/1 returns a import changeset" do
      user = user_fixture()
      import = import_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Imports.change_import(import)
    end
  end
end
