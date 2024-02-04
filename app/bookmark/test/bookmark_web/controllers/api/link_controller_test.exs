defmodule BookmarkWeb.Api.LinkControllerTest do
  use BookmarkWeb.ConnCase

  import Bookmark.AccountsFixtures
  import Bookmark.BookmarksFixtures

  @create_attrs %{
    description: "some description",
    title: "some title",
    url: "https://example.com"
  }
  @update_attrs %{}
  @invalid_attrs %{
    description: nil,
    title: nil,
    url: nil
  }
  @invalid_url_attrs %{
    description: "some description",
    title: "some title",
    url: "invalid URL"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all links for the logged-in user", %{conn: conn} do
      user_1 = user_fixture()
      user_2 = user_fixture()
      link_1 = link_fixture(%{user_id: user_1.id})
      _link_2 = link_fixture(%{user_id: user_2.id})

      conn =
        conn
        |> log_in_user(user_1)
        |> get(~p"/api/links")

      [
        %{
          "id" => id
        }
      ] = json_response(conn, 200)["data"]

      assert id == link_1.id
    end
  end

  describe "get link" do
    test "returns link if link exists", %{conn: conn} do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})
      %{id: id} = link

      conn =
        conn
        |> log_in_user(user)
        |> get(~p"/api/links/#{link}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "errors if link was not created by the logged-in user", %{conn: conn} do
      user_1 = user_fixture()
      user_2 = user_fixture()
      link = link_fixture(%{user_id: user_1.id})

      assert_error_sent 404, fn ->
        conn
        |> log_in_user(user_2)
        |> get(~p"/api/links/#{link}")
      end
    end

    test "errors if link does not exist", %{conn: conn} do
      user = user_fixture()

      assert_error_sent 404, fn ->
        conn
        |> log_in_user(user)
        |> get(~p"/api/links/841fa4f3-f860-43f9-8ad2-b1658d2350f1")
      end
    end
  end

  describe "create link" do
    test "renders link when data is valid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/api/links", link: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/links/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/api/links", link: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when url is invalid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/api/links", link: @invalid_url_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update link" do
    test "renders link when data is valid", %{conn: conn} do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})
      %{id: id} = link

      conn =
        conn
        |> log_in_user(user)
        |> put(~p"/api/links/#{link}", link: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/links/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})

      conn =
        conn
        |> log_in_user(user)
        |> put(~p"/api/links/#{link}", link: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when url is invalid", %{conn: conn} do
      user = user_fixture()
      link = link_fixture(%{user_id: user.id})

      conn =
        conn
        |> log_in_user(user)
        |> put(~p"/api/links/#{link}", link: @invalid_url_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when link was not created by logged in user", %{conn: conn} do
      user_1 = user_fixture()
      user_2 = user_fixture()
      link = link_fixture(%{user_id: user_1.id})

      assert_error_sent 404, fn ->
        conn
        |> log_in_user(user_2)
        |> put(~p"/api/links/#{link}", link: @update_attrs)
      end
    end

    test "renders errors when link does not exist", %{conn: conn} do
      user = user_fixture()

      assert_error_sent 404, fn ->
        conn
        |> log_in_user(user)
        |> put(~p"/api/links/841fa4f3-f860-43f9-8ad2-b1658d2350f1", link: @update_attrs)
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
        |> delete(~p"/api/links/#{link}")

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/links/#{link}")
      end
    end

    test "returns errors when link was not created by logged in user", %{conn: conn} do
      user_1 = user_fixture()
      user_2 = user_fixture()
      link = link_fixture(%{user_id: user_1.id})

      assert_error_sent 404, fn ->
        conn
        |> log_in_user(user_2)
        |> delete(~p"/api/links/#{link}")
      end
    end

    test "returns errors when link does not exist", %{conn: conn} do
      user = user_fixture()

      assert_error_sent 404, fn ->
        conn
        |> log_in_user(user)
        |> delete(~p"/api/links/841fa4f3-f860-43f9-8ad2-b1658d2350f1")
      end
    end
  end
end
