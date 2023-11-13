defmodule BookmarkWeb.Api.LinkJSON do
  alias Bookmark.Bookmarks.Link

  @doc """
  Renders a list of links.
  """
  def index(%{links: links}) do
    %{data: for(link <- links, do: data(link))}
  end

  @doc """
  Renders a single link.
  """
  def show(%{link: link}) do
    %{data: data(link)}
  end

  defp data(%Link{} = link) do
    %{
      id: link.id,
      url: link.url,
      title: link.title,
      description: link.description,
      favorite: link.favorite,
      to_read: link.to_read
    }
  end
end
