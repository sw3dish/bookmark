defmodule Bookmark.Imports.Import do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bookmark.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "imports" do
    field :data, :string
    field :type, :string
    field :status, :string
    field :count, :integer
    field :completed_at, :utc_datetime
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(import, attrs) do
    import
    |> cast(attrs, [:type, :data, :count, :status, :user_id, :completed_at])
    |> validate_required([:type, :user_id])
  end
end
