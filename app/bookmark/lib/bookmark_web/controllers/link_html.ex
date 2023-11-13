defmodule BookmarkWeb.LinkHTML do
  use BookmarkWeb, :html
  alias BookmarkWeb.Helpers.HTMLHelpers
  alias BookmarkWeb.Components.Components

  alias Bookmark.Bookmarks.Link

  embed_templates "link_html/*"

  @doc """
  Renders a link form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def link_form(assigns)

  def js(assigns)

  attr :link, Link

  def link_domain(assigns) do
    host = URI.parse(assigns.link).host
    scheme = URI.parse(assigns.link).scheme
    bare_url = %URI{host: host, scheme: scheme}

    assigns =
      assigns
      |> assign(:host, host)
      |> assign(:scheme, scheme)
      |> assign(:bare_url, bare_url)

    ~H"""
    <.link class="underline text-zinc-500 text-sm" href={@bare_url}>
      {<%= @host %>}
    </.link>
    """
  end

  attr :link, Link

  def link_favorite(assigns) do
    ~H"""
    <button x-data={~s|favorite(#{@link.favorite},"#{@link.id}")|} x-on:click="onClick">
      <span x-show="!favorite" x-cloak={@link.favorite}>
        <.icon class="text-zinc-300 hover:text-zinc-700" name="hero-heart" />
      </span>
      <span x-show="favorite" x-cloak={!@link.favorite}>
        <.icon name="hero-heart-solid hover:text-zinc-300" />
      </span>
    </button>
    """
  end

  def link_bookmarklet(assigns) do
    ~H"""
    <a href="javascript:(function() {
        fetch('http://localhost:4000/api/links', {
          headers: {
            'Content-Type': 'application/json'
        },
        method: 'POST',
        mode: 'no-cors',
          body: JSON.stringify({
            link: {
              url: window.location.href,
              title: document.title,
            } 
          })
        }) 
      })()">
      Read later - Bookmark
    </a>
    """
  end
end
