defmodule Bookmark.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string
      add :title, :string
      add :description, :text

      timestamps(type: :utc_datetime)
    end
  end
end
