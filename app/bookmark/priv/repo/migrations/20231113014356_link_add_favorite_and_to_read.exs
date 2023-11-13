defmodule Bookmark.Repo.Migrations.LinkAddFavoriteAndToRead do
  use Ecto.Migration

  def change do
    alter table("links") do
      add :favorite, :boolean, default: false
      add :to_read, :boolean, default: false
    end
  end
end
