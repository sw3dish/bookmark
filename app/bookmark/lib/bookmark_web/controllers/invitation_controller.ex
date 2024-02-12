defmodule BookmarkWeb.InvitationController do
  use BookmarkWeb, :controller

  def new(conn, _params) do
    changeset = Accounts.change_registration_token()
  end

  def create(conn, params) do
    
  end
end
