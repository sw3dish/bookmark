defmodule BookmarkWeb.InvitationHTML do
  use BookmarkWeb, :html

  alias BookmarkWeb.Helpers.HTMLHelpers

  embed_templates "invitation_html/*"

  @doc """
  Renders a invitation form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def invitation_form(assigns)
end
