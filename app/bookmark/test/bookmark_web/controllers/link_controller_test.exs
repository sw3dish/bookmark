defmodule BookmarkWeb.LinkControllerTest do
  use BookmarkWeb.ConnCase

  import Bookmark.AccountsFixtures
  import Bookmark.BookmarksFixtures

  @create_attrs %{
    description: "some description",
    title: "some title",
    url: "https://example.com"
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    url: "https://example.com/updated"
  }
  @invalid_attrs %{description: nil, title: nil, url: nil}
  @invalid_url_attrs %{
    description: "some description",
    title: "some title",
    url: "example.com"
  }

  describe "index" do
    test "lists all links for the logged-in user", %{conn: conn} do
      user_1 = user_fixture()
      user_2 = user_fixture()
      link_1 = link_fixture(%{user_id: user_1.id})
      link_2 = link_fixture(%{user_id: user_2.id})

      conn =
        conn
        |> log_in_user(user_1)
        |> get(~p"/")

      assert html_response(conn, 200) =~ link_1.title
      assert !(html_response(conn, 200) =~ link_2.title)
    end
  end

  describe "new link" do
    test "renders form", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> get(~p"/links/new")

      assert html_response(conn, 200) =~ "New Link"
    end
  end

  describe "create link" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/links", link: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/links/#{id}"

      conn = get(conn, ~p"/links/#{id}")
      assert html_response(conn, 200) =~ "Link #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/links", link: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Link"
    end

    test "renders errors when url is invalid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/links", link: @invalid_url_attrs)

      assert html_response(conn, 200) =~ "New Link"
    end
  end

  describe "show link" do
    test "shows link", %{conn: conn} do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})

      conn =
        conn
        |> log_in_user(user)
        |> get(~p"/links/#{link}/")

      assert html_response(conn, 200) =~ "Link #{link.id}"
    end

    test "not found if trying to show another user's link", %{conn: conn} do
      user = user_fixture()
      user_2 = user_fixture()
      link = link_fixture(%{user_id: user.id})

      assert_error_sent 404, fn ->
        conn
        |> log_in_user(user_2)
        |> get(~p"/links/#{link}/")
      end
    end
  end

  describe "edit link" do
    test "renders form for editing chosen link", %{conn: conn} do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})

      conn =
        conn
        |> log_in_user(user)
        |> get(~p"/links/#{link}/edit")

      assert html_response(conn, 200) =~ "Edit Link"
    end

    test "not found if trying to edit another user's link", %{conn: conn} do
      user = user_fixture()
      user_2 = user_fixture()
      link = link_fixture(%{user_id: user.id})

      assert_error_sent 404, fn ->
        conn
        |> log_in_user(user_2)
        |> get(~p"/links/#{link}/edit")
      end
    end
  end

  describe "update link" do
    test "redirects when data is valid", %{conn: conn} do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})

      conn =
        conn
        |> log_in_user(user)
        |> put(~p"/links/#{link}", link: @update_attrs)

      assert redirected_to(conn) == ~p"/links/#{link}"

      conn =
        conn
        |> get(~p"/links/#{link}")

      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})

      conn =
        conn
        |> log_in_user(user)
        |> put(~p"/links/#{link}", link: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Link"
    end

    test "not found if trying to update another user's link", %{conn: conn} do
      user = user_fixture()
      user_2 = user_fixture()
      link = link_fixture(%{user_id: user.id})

      assert_error_sent 404, fn ->
        conn
        |> log_in_user(user_2)
        |> put(~p"/links/#{link}", link: @update_attrs)
      end
    end
  end

  describe "delete link" do
    test "deletes chosen link", %{conn: conn} do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})

      conn =
        conn
        |> log_in_user(user)
        |> delete(~p"/links/#{link}")

      assert redirected_to(conn) == ~p"/"

      assert_error_sent 404, fn ->
        get(conn, ~p"/links/#{link}")
      end
    end

    test "not found if trying to delete another user's link", %{conn: conn} do
      user = user_fixture()
      user_2 = user_fixture()
      link = link_fixture(%{user_id: user.id})

      assert_error_sent 404, fn ->
        conn
        |> log_in_user(user_2)
        |> delete(~p"/links/#{link}")
      end
    end
  end
end
