defmodule Memo.EntryJob do
  use GenServer

  @job_duration 60_000

  # === Client API ===

  def progress(pid) do
    GenServer.call(pid, :progress)
  end

  # === Utilities ===

  def process_name_for_key(key) do
    {:via, Registry, {Registry.Memo, {EntryJob, key}}}
  end

  def start_job_for(key) do
    case Supervisor.start_child(Memo.EntryJobSupervisor, [key]) do
      {:ok, _pid} ->
        :ok
      {:error, error} ->
        {:error, error}
    end
  end

  def pid_for_key(key) do
    key
    |> process_name_for_key()
    |> GenServer.whereis()
  end

  # === Server ===

  def start_link(key) do
    GenServer.start_link(__MODULE__, key, name: process_name_for_key(key))
  end

  def init(key) do
    IO.puts "starting job for: \"#{key}\"..."

    start_time = System.system_time(:milliseconds)

    duration = round(:rand.normal() * 20_000 + @job_duration) |> max(10_000)
    Process.send_after(self(), :exit, duration)

    schedule_work()

    {:ok, {start_time, duration, key}}
  end

  def handle_call(:progress, _from, state) do
    {:reply, do_progress(state), state}
  end

  def handle_info(:schedule_work, {_, _, key} = state) do
    percentage = round(do_progress(state) * 100)
    IO.puts "working on \"#{key}\"... (#{inspect percentage}%)"

    schedule_work()

    {:noreply, state}
  end

  def handle_info(:exit, {_, _, key}) do
    IO.puts "DONE: \"#{key}\""
    {:stop, :normal, key}
  end

  defp do_progress({start_time, duration, _}) do
    (System.system_time(:milliseconds) - start_time) / duration
  end

  defp schedule_work() do
    estimate = round((:rand.normal() * 1_000) + 5_000) |> max(100)
    Process.send_after(self(), :schedule_work, estimate)
  end
end
