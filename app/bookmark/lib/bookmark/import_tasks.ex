defmodule Bookmark.ImportTasks do
  alias Bookmark.Imports

  def import_links_from_pinboard(import_id, file_contents, current_user) do
    Task.Supervisor.start_child(Bookmark.ImportTaskSupervisor, fn ->
      links_to_import = Jason.decode!(file_contents)

      {count, errors} =
        Enum.reduce(links_to_import, {0, []}, fn link, {count, errors} ->
          with {:ok, pinboard_link} <- Imports.create_pinboard_link(link),
               {:ok, _} <- Imports.import_link_from_pinboard(pinboard_link, current_user) do
            {count + 1, errors}
          else
            {:error, %Ecto.Changeset{errors: changeset_errors}} ->
              {count, errors ++ [{link, changeset_errors}]}
          end
        end)

      import = Imports.get_import!(import_id, current_user)

      Imports.update_import(import, %{
        errors: errors,
        count: count,
        status: "completed",
        completed_at: NaiveDateTime.local_now()
      })
    end)
  end
end
