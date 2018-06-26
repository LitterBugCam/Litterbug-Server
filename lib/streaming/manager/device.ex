defmodule Streaming.Manager.Device do
  use Ecto.Schema
  import Ecto.Changeset


  schema "devices" do
    field :mac_addr, :string
    field :published_at, :naive_datetime
    field :title, :string
    belongs_to :user,  Streaming.Auth.User
    has_many :events, Streaming.Manager.Device

    timestamps()
  end



  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:title,  :mac_addr])
    |> validate_required([:title,  :mac_addr])
  end
end
