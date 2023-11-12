defmodule Bookmark.ImportTasks do
  alias Bookmark.Imports

  def import_links_from_pinboard(import_id, file_contents) do
      Task.Supervisor.start_child(Bookmark.ImportTaskSupervisor, fn ->
        links_to_import = Jason.decode!(file_contents)
        errors =  Enum.reduce(links_to_import, [], fn link, errors -> 
          with {:ok, pinboard_link}<- Imports.convert_pinboard_link(link),
               {:ok, _} <- Imports.import_link_from_pinboard(pinboard_link) do
            errors
          else
            {:error, %Ecto.Changeset{errors: changeset_errors}} -> errors ++ [{link, changeset_errors}]
          end
        end)
        IO.inspect(errors)
        # %Import{errors: errors} = Bookmarks.get_import!(import_id)

      end)
  end
end
