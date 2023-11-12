defmodule Bookmark.Imports.PinboardImportLink do
  use Ecto.Schema
  import Ecto.Changeset
  import Changeset.Validator

  @primary_key false
  embedded_schema do
    field :description, :string
    field :href, :string
    field :extended, :string
    field :time, :utc_datetime
    field :toread, :string
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:href, :description, :extended, :time, :toread])
    |> validate_required([:href, :time, :toread])
    |> validate_is_valid_url(:href)
  end
end
