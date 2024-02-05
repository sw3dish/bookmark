defmodule BookmarkWeb.Components.Nav do
  use Phoenix.Component, global_prefixes: ["x-"]

  embed_templates "nav/*"

  attr :active_classes, :string, default: "bg-zinc-900 text-white "
  attr :inactive_classes, :string, default: "bg-white text-zinc-900"
  attr :hover_classes, :string, default: "hover:bg-zinc-900 hover:text-white"
  attr :href, :string, required: true
  attr :conn, Plug.Conn, required: true
  
  slot :inner_block, required: true

  def link(assigns)
end
