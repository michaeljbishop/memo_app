alias Memo.Repo
alias Memo.Data.Entry
alias Memo.EntryJob

defmodule Debug do
  def restart_memo do
    Process.exit(GenServer.whereis(Memo), :kill)
  end
  def kill_job(key) do
    Process.exit(EntryJob.pid_for_key(key), :kill)
  end
end
