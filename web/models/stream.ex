defmodule  Streaming.Stream do
  use Streaming.Web, :model
  alias Streaming.Auth.User

  schema "devices" do
    field :mac_addr, :string

    belongs_to :user,  Streaming.Auth.User

  end




end
