defmodule Streaming.Repo.Migrations.AddKeyEventTable do
  use Ecto.Migration

  def change do
             alter table(:events) do
          add :detection, :string



  end
  end
end
