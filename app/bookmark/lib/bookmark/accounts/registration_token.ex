defmodule Bookmark.Accounts.RegistrationToken do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Bookmark.Accounts.User

  @hash_algorithm :sha256
  @rand_size 32
  @token_validity_in_days 7

  @foreign_key_type :binary_id
  schema "registration_tokens" do
    field :token, :binary
    field :token_string, :string
    field :scoped_to_email, :string
    belongs_to :used_by_user, User, foreign_key: :used_by_user_id
    belongs_to :generated_by_user, User, foreign_key: :generated_by_user_id

    timestamps()
  end

  def build_hashed_token() do
    token_string = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token_string)
    {Base.url_encode64(token_string, padding: false), hashed_token}
  end

  def public_create_changeset(token, attrs) do
    token
    |> cast(attrs, [:scoped_to_email])
    |> validate_required([:scoped_to_email])
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:token, :token_string, :scoped_to_email, :generated_by_user_id])
    |> validate_required([:token, :token_string, :scoped_to_email, :generated_by_user_id])
    |> foreign_key_constraint(:generated_by_user_id)
  end

  def consume_token_changeset(token, user_id) do
    token
    |> cast(%{used_by_user_id: user_id}, [:used_by_user_id])
    |> unique_constraint(:used_by_user_id)
  end

  def get_registration_token_query(token) do
    from(rt in __MODULE__,
      where: rt.token == ^token,
      where: rt.inserted_at > ago(@token_validity_in_days, "day"),
      where: is_nil(rt.used_by_user_id)
    )
  end
end
