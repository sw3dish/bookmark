defmodule Bookmark.Repo.Migrations.RemoveOldIdPkAndConstraints do
  use Ecto.Migration

  def change do
    # Drop FK constraints
    drop(constraint(:imports, "imports_user_id_fkey"))
    drop(constraint(:links, "links_user_id_fkey"))
    drop(constraint(:registration_tokens, "registration_tokens_generated_by_user_id_fkey"))
    drop(constraint(:registration_tokens, "registration_tokens_used_by_user_id_fkey"))
    drop(constraint(:users_tokens, "users_tokens_user_id_fkey"))

    # Make uuid new primary key
    alter table(:users) do
      remove :id
      modify :uuid, :binary_id, primary_key: true
    end

    rename table(:users), :uuid, to: :id
    
    # swap to using new user id as foreign key
    # by dropping old column, renaming new column, add foreign key index to new column
    alter table(:imports) do
      remove :user_id
    end

    rename table(:imports), :user_uuid, to: :user_id

    flush()

    alter table(:imports) do
      modify :user_id, references(:users, type: :binary_id)   
    end

    alter table(:links) do
      remove :user_id
    end

    rename table(:links), :user_uuid, to: :user_id

    flush()

    alter table(:links) do
      modify :user_id, references(:users, type: :binary_id)   
    end

    alter table(:registration_tokens) do
      remove :generated_by_user_id
      remove :used_by_user_id
    end

    rename table(:registration_tokens), :generated_by_user_uuid, to: :generated_by_user_id
    rename table(:registration_tokens), :used_by_user_uuid, to: :used_by_user_id

    flush()

    alter table(:registration_tokens) do
      modify :generated_by_user_id, references(:users, type: :binary_id)
      modify :used_by_user_id, references(:users, type: :binary_id)
    end

    alter table(:users_tokens) do
      remove :user_id
    end

    rename table(:users_tokens), :user_uuid, to: :user_id

    flush()

    alter table(:users_tokens) do
      modify :user_id, references(:users, type: :binary_id)
    end
  end
end
