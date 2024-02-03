defmodule BookmarkWeb.ImportControllerTest do
  use BookmarkWeb.ConnCase

  import Bookmark.ImportsFixtures

  @create_attrs %{data: "some data", type: "some type"}
  @update_attrs %{data: "some updated data", type: "some updated type"}
  @invalid_attrs %{data: nil, type: nil}

  describe "index" do
    test "lists all imports", %{conn: conn} do
      conn = get(conn, ~p"/imports")
      assert html_response(conn, 200) =~ "Listing Imports"
    end
  end

  describe "new import" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/imports/new")
      assert html_response(conn, 200) =~ "New Import"
    end
  end

  describe "create import" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/imports", import: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/imports/#{id}"

      conn = get(conn, ~p"/imports/#{id}")
      assert html_response(conn, 200) =~ "Import #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/imports", import: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Import"
    end
  end

  describe "edit import" do
    setup [:create_import]

    test "renders form for editing chosen import", %{conn: conn, import: import} do
      conn = get(conn, ~p"/imports/#{import}/edit")
      assert html_response(conn, 200) =~ "Edit Import"
    end
  end

  describe "update import" do
    setup [:create_import]

    test "redirects when data is valid", %{conn: conn, import: import} do
      conn = put(conn, ~p"/imports/#{import}", import: @update_attrs)
      assert redirected_to(conn) == ~p"/imports/#{import}"

      conn = get(conn, ~p"/imports/#{import}")
      assert html_response(conn, 200) =~ "some updated data"
    end

    test "renders errors when data is invalid", %{conn: conn, import: import} do
      conn = put(conn, ~p"/imports/#{import}", import: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Import"
    end
  end

  describe "delete import" do
    setup [:create_import]

    test "deletes chosen import", %{conn: conn, import: import} do
      conn = delete(conn, ~p"/imports/#{import}")
      assert redirected_to(conn) == ~p"/imports"

      assert_error_sent 404, fn ->
        get(conn, ~p"/imports/#{import}")
      end
    end
  end

  defp create_import(_) do
    import = import_fixture()
    %{import: import}
  end
end
