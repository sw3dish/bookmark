defmodule Bookmark.Repo.Migrations.ImportsAddCompletedAt do
  use Ecto.Migration

  def change do
    alter table(:imports) do
      add :completed_at, :utc_datetime
    end
  end
end
