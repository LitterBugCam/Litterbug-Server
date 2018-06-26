defmodule Streaming.Repo.Migrations.EventTable do
  use Ecto.Migration

  def change do
   create table(:events) do
        add :confidence, :float
        add :date, :datetime
        add :device_id, references(:devices)
	timestamps
      end
  end
end
