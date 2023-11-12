defmodule Bookmark.Repo.Migrations.ImportsChangeStatusDefault do
  use Ecto.Migration

  def change do
    alter table("imports") do
      modify :status, :string, default: "pending"
    end
  end
end
