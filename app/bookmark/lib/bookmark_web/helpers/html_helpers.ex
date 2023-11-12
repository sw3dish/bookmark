defmodule BookmarkWeb.Helpers.HTMLHelpers do
  alias Timex

  def get_human_readable_local_datetime!(date) do
    Timex.format!(Timex.to_datetime(date, "America/New_York"), "%Y-%m-%d at %l:%M %P", :strftime)
  end
end
