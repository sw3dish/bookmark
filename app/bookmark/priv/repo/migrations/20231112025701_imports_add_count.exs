defmodule Bookmark.Repo.Migrations.ImportsAddCount do
  use Ecto.Migration

  def change do
    alter table("imports") do
      add :count, :integer
    end
  end
end
