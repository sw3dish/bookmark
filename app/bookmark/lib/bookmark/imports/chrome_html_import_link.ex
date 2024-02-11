defmodule Bookmark.Imports.ChromeHtmlImportLink do
  use Ecto.Schema
  import Ecto.Changeset
  import Changeset.Validator

  @primary_key false
  embedded_schema do
    field :title, :string
    field :url, :string
    field :inserted_at, :utc_datetime
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:title, :url, :inserted_at])
    |> validate_required([:title, :url, :inserted_at])
    |> validate_is_valid_url(:url)
  end
end
