defmodule Memo.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :key, :string
      add :value, :string

      timestamps()
    end
    create unique_index(:entries, :key)
  end
end
