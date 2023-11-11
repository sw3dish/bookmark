defmodule Changeset.Validator do
  import Ecto.Changeset

  def validate_is_valid_url(changeset, field) when is_atom(field) do
    validate_change(changeset, field, fn field, value ->
      case URI.parse(value) do
        %URI{scheme: nil} -> [{field, "is missing a scheme (e.g. https://)"}]
        %URI{host: nil} -> [{field, "is missing a host (e.g. example.com)"}]
        _ -> []
      end
    end)
  end
end
