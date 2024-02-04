defmodule Bookmark.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bookmark.Accounts` context.
  """
  alias Bookmark.Accounts.User
  alias Bookmark.Repo

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    attrs = valid_user_attributes(attrs)

    {:ok, user} =
      %User{}
      |> User.registration_changeset(attrs)
      |> User.confirm_changeset()
      |> Repo.insert()

    user
  end

  def unconfirmed_user_fixture(attrs \\ %{}) do
    attrs = valid_user_attributes(attrs)

    {:ok, user} =
      %User{}
      |> User.registration_changeset(attrs)
      |> Repo.insert()

    user
  end

  def registration_token_fixture(%{
    scoped_to_email: email,
    generated_by_user_id: user_id
  }) do
    {:ok, token} =
      Bookmark.Accounts.generate_registration_token(scoped_to_email: email, generated_by_user_id: user_id)

    token
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
