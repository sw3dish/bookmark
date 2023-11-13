defmodule BookmarkWeb.Helpers.HTMLHelpers do
  alias Timex

  def get_human_readable_local_datetime!(date, format_string \\ "%Y-%m-%d at %l:%M %P") do
    Timex.format!(
      Timex.to_datetime(date, "America/New_York"), format_string, :strftime
    )
  end
end
