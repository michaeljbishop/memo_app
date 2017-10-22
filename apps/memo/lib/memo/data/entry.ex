defmodule Memo.Data.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  alias Memo.Repo
  import Ecto.Query, only: [from: 2]

  schema "entries" do
    field :key, :string
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(%Entry{} = entry, attrs) do
    entry
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
    |> unique_constraint(:key)
  end
  
  def all() do
    Repo.all(Entry)
  end

  def upsert(key, value) do
    %Entry{}
    |> changeset(%{key: key, value: value})
    |> Repo.insert_or_update()
  end

  def delete(key) do
    Repo.delete_all(from e in Entry, where: e.key == ^key)
  end
end
