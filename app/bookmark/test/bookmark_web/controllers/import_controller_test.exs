defmodule BookmarkWeb.ImportControllerTest do
  use BookmarkWeb.ConnCase

  import Bookmark.AccountsFixtures
  import Bookmark.ImportsFixtures

  @create_attrs %{
    data:
      ~s([{"href":"https:\/\/example.com","description":"Example","extended":"","meta":"e653450e811a7c19b70551bb77f9d06f","hash":"c891614ca3c38243958fcda3f914cb5c","time":"2024-02-03T02:55:49Z","shared":"no","toread":"yes","tags":""}]),
    type: :pinboard
  }
  @update_attrs %{data: "some updated data", type: :pinboard}
  @invalid_attrs %{data: nil, type: nil}
  @invalid_type_attrs %{data: "invalid data", type: :invalid}

  describe "index" do
    test "lists all imports for the logged-in user", %{conn: conn} do
      user_1 = user_fixture()
      user_2 = user_fixture()

      import_1 = import_fixture(user_id: user_1.id)
      import_2 = import_fixture(user_id: user_2.id)

      conn =
        conn
        |> log_in_user(user_1)
        |> get(~p"/imports")

      assert html_response(conn, 200) =~ import_1.id
      assert !(html_response(conn, 200) =~ import_2.id)
    end
  end

  describe "new import" do
    test "renders form", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> get(~p"/imports/new")

      assert html_response(conn, 200) =~ "New Import"
    end
  end

  describe "create import" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/imports", import: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/imports/#{id}"

      conn = get(conn, ~p"/imports/#{id}")
      assert html_response(conn, 200) =~ "Import #{id}"

      # Clean up tasks from the import
      on_exit(fn ->
        for pid <- Task.Supervisor.children(Bookmark.ImportTaskSupervisor) do
          ref = Process.monitor(pid)
          assert_receive {:DOWN, ^ref, _, _, _}, 1000
        end
      end)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/imports", import: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Import"
    end

    test "renders errors when type is invalid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/imports", import: @invalid_type_attrs)

      assert html_response(conn, 200) =~ "New Import"
      assert html_response(conn, 200) =~ "invalid data"
    end
  end

  describe "edit import" do
    test "errors since imports cannot be edited", %{conn: conn} do
      user = user_fixture()
      import = import_fixture(%{user_id: user.id})

      conn =
        conn
        |> log_in_user(user)
        |> get("/imports/#{import.id}/edit")

      assert conn.status == 404
    end
  end

  describe "update import" do
    test "errors since imports cannot be updated", %{conn: conn} do
      user = user_fixture()
      import = import_fixture(%{user_id: user.id})

      conn =
        conn
        |> log_in_user(user)
        |> put("/imports/#{import.id}", import: @update_attrs)

      assert conn.status == 404
    end
  end

  describe "delete import" do
    test "deletes chosen import", %{conn: conn} do
      user = user_fixture()
      import = import_fixture(%{user_id: user.id})

      conn =
        conn
        |> log_in_user(user)
        |> delete("/imports/#{import.id}")

      assert conn.status == 404
    end
  end
end
