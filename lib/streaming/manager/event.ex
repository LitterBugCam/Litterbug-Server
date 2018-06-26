defmodule Streaming.Manager.Event do
  use Ecto.Schema
  import Ecto.Changeset




  schema "events" do
    field :confidence, :float
    field :date, :naive_datetime
    field :detection, :string
    belongs_to :device,  Streaming.Manager.Device
  #  timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:confidence,  :date])
    |> validate_required([:confidence,  :date])
  end
end
