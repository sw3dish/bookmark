defmodule Bookmark.Repo.Migrations.CreateImports do
  use Ecto.Migration

  def change do
    create table(:imports, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :data, :text

      timestamps(type: :utc_datetime)
    end
  end
end
