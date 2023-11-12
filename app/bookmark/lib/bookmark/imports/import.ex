defmodule Bookmark.Imports.Import do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "imports" do
    field :data, :string
    field :type, :string
    field :status, :string
    field :completed_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(import, attrs) do
    import
    |> cast(attrs, [:type, :data, :status, :completed_at])
    |> validate_required([:type])
  end
end
