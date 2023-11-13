defmodule BookmarkWeb.ImportHTML do
  use BookmarkWeb, :html

  alias BookmarkWeb.Helpers.HTMLHelpers

  embed_templates "import_html/*"

  @doc """
  Renders a import form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def import_form(assigns)
end
