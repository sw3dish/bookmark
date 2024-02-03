defmodule Bookmark.Bookmarks.Link do
  use Ecto.Schema
  import Ecto.Changeset
  import Changeset.Validator

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "links" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :favorite, :boolean, default: false
    field :to_read, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :title, :description, :favorite, :to_read, :inserted_at])
    |> validate_required([:url])
    |> validate_is_valid_url(:url)
  end
end
