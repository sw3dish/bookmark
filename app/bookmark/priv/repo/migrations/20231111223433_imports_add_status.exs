defmodule Bookmark.Repo.Migrations.ImportsAddStatus do
  use Ecto.Migration

  def change do
    alter table("imports") do
      add :status, :string
    end
  end
end
