alias Memo.Repo
alias Memo.Data.Entry

defmodule Debug do
  def restart_memo do
    Process.exit(GenServer.whereis(Memo), :kill)
  end
end
