defmodule MemoWeb.EntryController do
  use MemoWeb, :controller

  require Logger
  alias Memo.EntryJob

  def index(conn, _params) do
    {:ok, all} = Memo.all()
    all = Enum.map(all, fn {key, value} ->
      {key, value, job_progress(key)}
    end)
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
    job_progress = job_progress(id)
    
    render(conn, "show.html", value: value, id: id, job_progress: job_progress)
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

  def start_job(conn, %{"id" => id}) do
    case EntryJob.start_job_for(id) do
      :ok ->
        conn
        |> put_flash(:info, "EntryJob started successfully.")
        |> redirect(to: entry_path(conn, :index))
      {:error, error} ->
        Logger.warn(inspect(error))
        conn
        |> put_flash(:error, inspect(error))
        |> redirect(to: entry_path(conn, :show, id))
    end
  end

  defp job_progress(key) do
    case EntryJob.pid_for_key(key) do
      nil -> nil
      pid -> EntryJob.progress(pid)
    end
  end
end
