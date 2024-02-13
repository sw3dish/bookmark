defmodule BookmarkWeb.InvitationController do
  use BookmarkWeb, :controller
  alias Bookmark.Accounts
  alias Bookmark.Accounts.UserNotifier
  alias Bookmark.Accounts.RegistrationToken

  def new(conn, _params) do
    changeset = Accounts.public_create(%RegistrationToken{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"registration_token" => %{"scoped_to_email" => email}}) do
    current_user = conn.assigns.current_user
    case Accounts.generate_registration_token(scoped_to_email: email, generated_by_user_id: current_user.id) do
      {:ok, token}  ->
        UserNotifier.deliver_invitation(email, url(~p"/users/register/#{token.token_string}"))
        conn
        |> put_flash(:info, "#{email} has been invited!")
        |> redirect(to: ~p"/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
