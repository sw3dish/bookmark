defmodule Bookmark.Bookmarks.Link do
  use Ecto.Schema
  import Ecto.Changeset
  import Changeset.Validator
  alias Bookmark.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "links" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :favorite, :boolean, default: false
    field :to_read, :boolean, default: false
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :title, :description, :favorite, :to_read, :user_id, :inserted_at])
    |> validate_required([:url, :user_id])
    |> validate_is_valid_url(:url)
  end
end
