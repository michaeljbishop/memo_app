defmodule MemoWeb.EntryController do
  use MemoWeb, :controller

  def index(conn, _params) do
    {:ok, all} = Memo.all()
    
    render(conn, "index.html", entries: all)
  end

  def new(conn, _params) do
    render(conn, "new.html", [])
  end

  def create(conn, %{"entry" => %{"key" => key, "value" => value}}) do
    :ok = Memo.set(key, value)

    conn
    |> put_flash(:info, "Entry created successfully.")
    |> redirect(to: entry_path(conn, :show, key))
  end

  def show(conn, %{"id" => id}) do
    {:ok, value} = Memo.get(id)
    
    render(conn, "show.html", value: value, id: id)
  end

  def edit(conn, %{"id" => id}) do
    {:ok, entry} = Memo.get(id)
    
    render(conn, "edit.html", id: id, value: entry)
  end

  def update(conn, %{"id" => id, "entry" => %{"value" => value}}) do
    :ok = Memo.set(id, value)
    
    conn
    |> put_flash(:info, "Entry updated successfully.")
    |> redirect(to: entry_path(conn, :show, id))
  end

  def delete(conn, %{"id" => id}) do
    {:ok, _entry} = Memo.delete(id)

    conn
    |> put_flash(:info, "Entry deleted successfully.")
    |> redirect(to: entry_path(conn, :index))
  end
end
