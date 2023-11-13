defmodule BookmarkWeb.Components.Components do
  use Phoenix.Component, global_prefixes: ["x-"]

  embed_templates "components/*"

  def js_scripts(assigns)
end
