defmodule Streaming.Repo do
  use Ecto.Repo, otp_app: :streaming
use Scrivener, page_size: 10
end
