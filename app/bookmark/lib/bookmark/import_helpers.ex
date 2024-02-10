defmodule Bookmark.ImportHelpers do
  use Timex

  def get_date_from_netscape_date(date) do
    start_date = Timex.to_datetime(Timex.epoch)
    Timex.shift(start_date, seconds: String.to_integer(date))
  end
end
