defmodule BookmarkWeb.UserRegistrationLiveTest do
  use BookmarkWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bookmark.AccountsFixtures

  describe "Registration page" do
    test "registration page without token errors", %{conn: conn} do
      %{status: status} = get(conn, "/users/register")
      assert status == 404
    end

    test "renders registration page", %{conn: conn} do
      email = unique_user_email()
      inviting_user = user_fixture()
      token = registration_token_fixture(%{
        scoped_to_email: email,
        generated_by_user_id: inviting_user.id,
      })

      {:ok, _lv, html} = live(conn, ~p"/users/register/#{token.token_string}")

      assert html =~ "Register"
      assert html =~ "Create an account"
      assert html =~ "Sign in"
    end

    test "redirects if already logged in", %{conn: conn} do
      email = unique_user_email()
      inviting_user = user_fixture()
      token = registration_token_fixture(%{
        scoped_to_email: email,
        generated_by_user_id: inviting_user.id,
      })

      result =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/users/register/#{token.token_string}")
        |> follow_redirect(conn, "/")

      assert {:ok, _conn} = result
    end

    test "renders errors for invalid data", %{conn: conn} do
      email = unique_user_email()
      inviting_user = user_fixture()
      token = registration_token_fixture(%{
        scoped_to_email: email,
        generated_by_user_id: inviting_user.id,
      })

      {:ok, lv, _html} = live(conn, ~p"/users/register/#{token.token_string}")

      result =
        lv
        |> element("#registration_form")
        |> render_change(user: %{"email" => "with spaces", "password" => "too short"})

      assert result =~ "Create an account"
      assert result =~ "must have the @ sign and no spaces"
      assert result =~ "should be at least 12 character"
    end
  end

  describe "register user" do
    test "creates account and ensure that the user still needs to confirm", %{conn: conn} do
      email = unique_user_email()
      inviting_user = user_fixture()
      token = registration_token_fixture(%{
        scoped_to_email: email,
        generated_by_user_id: inviting_user.id,
      })

      {:ok, lv, _html} = live(conn, ~p"/users/register/#{token.token_string}")

      form = form(lv, "#registration_form", user: valid_user_attributes(email: email))
      render_submit(form)

      flash = assert_redirected(lv, ~p"/users/log_in")
      assert flash["info"] =~ "Your account has been created!"

      # ensure that we are still redirected to log in
      conn = get(conn, "/")
      assert redirected_to(conn) == "/users/log_in"
    end

    test "renders errors for duplicated email", %{conn: conn} do
      email = unique_user_email()
      inviting_user = user_fixture()
      token = registration_token_fixture(%{
        scoped_to_email: email,
        generated_by_user_id: inviting_user.id,
      })

      {:ok, lv, _html} = live(conn, ~p"/users/register/#{token.token_string}")

      user_fixture(%{email: email})

      result =
        lv
        |> form("#registration_form",
          user: %{"email" => email, "password" => "valid_password"}
        )
        |> render_submit()

      assert result =~ "has already been taken"
    end
  end

  describe "registration navigation" do
    test "redirects to login page when the Sign in button is clicked", %{conn: conn} do
      email = unique_user_email()
      inviting_user = user_fixture()
      token = registration_token_fixture(%{
        scoped_to_email: email,
        generated_by_user_id: inviting_user.id,
      })

      {:ok, lv, _html} = live(conn, ~p"/users/register/#{token.token_string}")

      {:ok, _login_live, login_html} =
        lv
        |> element(~s|main a:fl-contains("Sign in")|)
        |> render_click()
        |> follow_redirect(conn, ~p"/users/log_in")

      assert login_html =~ "Sign in"
    end
  end
end
