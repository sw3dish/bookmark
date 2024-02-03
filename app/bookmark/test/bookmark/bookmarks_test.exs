defmodule Bookmark.BookmarksTest do
  use Bookmark.DataCase

  alias Bookmark.Bookmarks

  describe "links" do
    alias Bookmark.Bookmarks.Link

    import Bookmark.AccountsFixtures
    import Bookmark.BookmarksFixtures

    @invalid_attrs %{description: nil, title: nil, url: nil}
    @invalid_url_attrs %{
      description: "some description",
      title: "some title",
      url: "invalid URL",
      favorite: true,
      to_read: true
    }

    test "list_links/1 returns all links created by a certain user" do
      user_1 = user_fixture()
      user_2 = user_fixture()
      link_1 = link_fixture(%{user_id: user_1.id})
      _link_2 = link_fixture(%{user_id: user_2.id})
      assert Bookmarks.list_links(user_1) == [link_1]
    end

    test "list_links/1 returns links sorted by reverse created date" do
      user = user_fixture()
      link_1 = link_fixture(%{user_id: user.id, inserted_at: ~U[2024-02-03 21:12:52Z]})
      link_2 = link_fixture(%{user_id: user.id, inserted_at: ~U[2024-02-03 21:12:59Z]})
      assert Bookmarks.list_links(user) == [link_2, link_1]
    end

    test "get_link!/2 returns the link with given id for the given user" do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})
      assert Bookmarks.get_link!(link.id, user) == link
    end

    test "get_link!/2 raises an error when a link with given id is not passed the user that created it" do
      user_1 = user_fixture()
      user_2 = user_fixture()
      link = link_fixture(%{user_id: user_2.id})

      assert_raise Ecto.NoResultsError, fn ->
        Bookmarks.get_link!(link.id, user_1)
      end
    end

    test "create_link/1 with valid data creates a link" do
      user = user_fixture()

      valid_attrs = %{
        description: "some description",
        title: "some title",
        url: "https://example.com",
        favorite: true,
        to_read: true,
        user_id: user.id
      }

      assert {:ok, %Link{} = link} = Bookmarks.create_link(valid_attrs)
      assert link.description == "some description"
      assert link.title == "some title"
      assert link.url == "https://example.com"
      assert link.favorite == true
      assert link.to_read == true
      assert link.user_id == user.id
    end

    test "create_link/1 with invalid URL returns error changeset" do
      user = user_fixture()
      invalid_url_attrs = Map.put(@invalid_url_attrs, :user_id, user.id)
      assert {:error, %Ecto.Changeset{}} = Bookmarks.create_link(invalid_url_attrs)
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookmarks.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})

      update_attrs = %{
        description: "some updated description",
        title: "some updated title",
        url: "https://example.com/updated",
        favorite: false,
        to_read: false
      }

      assert {:ok, %Link{} = link} = Bookmarks.update_link(link, update_attrs)
      assert link.description == "some updated description"
      assert link.title == "some updated title"
      assert link.url == "https://example.com/updated"
      assert link.favorite == false
      assert link.to_read == false
    end

    test "update_link/2 with invalid URL returns error changeset" do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Bookmarks.update_link(link, @invalid_url_attrs)
      assert link == Bookmarks.get_link!(link.id, user)
    end

    test "update_link/2 with invalid data returns error changeset" do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Bookmarks.update_link(link, @invalid_attrs)
      assert link == Bookmarks.get_link!(link.id, user)
    end

    test "delete_link/1 deletes the link" do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})
      assert {:ok, %Link{}} = Bookmarks.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Bookmarks.get_link!(link.id, user) end
    end

    test "change_link/1 returns a link changeset" do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Bookmarks.change_link(link)
    end
  end
end
