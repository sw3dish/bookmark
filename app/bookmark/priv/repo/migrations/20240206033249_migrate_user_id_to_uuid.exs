defmodule Bookmark.Repo.Migrations.MigrateUserIdToUuid do
  use Ecto.Migration
  import Ecto.Query, only: [from: 2]

  alias Bookmark.Repo
  alias Bookmark.Accounts.User

  def change do
    # Create new id
    alter table(:users) do
      add :uuid, :binary_id
    end

    # Create new FK columns
    alter table(:imports) do
      add :user_uuid, :binary_id
    end

    alter table(:links) do
      add :user_uuid, :binary_id
    end

    alter table(:registration_tokens) do
      add :generated_by_user_uuid, :binary_id
      add :used_by_user_uuid, :binary_id
    end

    alter table(:users_tokens) do
      add :user_uuid, :binary_id
    end

    flush()

    # Create UUIDs for the new id
    users = from(u in User, select: u) |> Repo.all()

    Enum.each(users, fn user ->
      uuid = Ecto.UUID.bingenerate()

      from(u in "users", where: u.id == ^user.id, update: [set: [uuid: ^uuid]])
      |> Repo.update_all([])
    end)

    # Copy over the proper user uuid based on previous user id
    from(i in "imports",
      join: u in "users",
      on: i.user_id == u.id,
      update: [set: [user_uuid: u.uuid]]
    )
    |> Repo.update_all([])

    from(l in "links",
      join: u in "users",
      on: l.user_id == u.id,
      update: [set: [user_uuid: u.uuid]]
    )
    |> Repo.update_all([])

    from(rt in "registration_tokens",
      join: u in "users",
      on: rt.generated_by_user_id == u.id,
      update: [set: [generated_by_user_uuid: u.uuid]]
    )
    |> Repo.update_all([])

    from(rt in "registration_tokens",
      join: u in "users",
      on: rt.used_by_user_id == u.id,
      update: [set: [used_by_user_uuid: u.uuid]]
    )
    |> Repo.update_all([])

    from(ut in "users_tokens",
      join: u in "users",
      on: ut.user_id == u.id,
      update: [set: [user_uuid: u.uuid]]
    )
    |> Repo.update_all([])
  end
end
