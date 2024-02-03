defmodule Bookmark.Repo.Migrations.ImportAddUserId do
  use Ecto.Migration

  def change do
    alter table("imports") do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:imports, [:user_id])
  end
end
