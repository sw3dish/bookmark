defmodule Bookmark.Repo.Migrations.LinkAddUserId do
  use Ecto.Migration

  def change do
    alter table("links") do
      add :user_id, references(:users, on_delete: :delete_all) 
    end

    create index(:links, [:user_id])
  end
end
