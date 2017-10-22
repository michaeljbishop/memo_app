defmodule Memo do
  use GenServer
  require Logger

  alias Memo.Data.Entry

  # === Client API ===

  def all() do
    GenServer.call(__MODULE__, :all)
  end

  def set(key, value) do
    GenServer.call(__MODULE__, {:set, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def keys() do
    GenServer.call(__MODULE__, :keys)
  end

  def delete(key) do
    GenServer.call(__MODULE__, {:delete, key})
  end

  def add_callback(module, function, args \\ []) do
    GenServer.call(__MODULE__, {:add_callback, module, function, args})
  end

  # === Server ===

  @enforce_keys [:callbacks, :entries]
  defstruct @enforce_keys

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    entries = Enum.reduce(Entry.all(), %{}, fn %Entry{key: key, value: value}, acc ->
      Map.put(acc, key, value)
    end)

    Logger.debug """
    Started Memo
    #{inspect entries, pretty: true}
    """
    default_callback = [__MODULE__, :handle_memo_message, []]

    {:ok, %__MODULE__{entries: entries, callbacks: [default_callback]}}
  end

  def handle_memo_message(message) do
    Logger.debug("Received Memo message: #{inspect message}")
  end

  def handle_call(:all, _from, state) do
    {:reply, {:ok, state.entries}, state}
  end

  def handle_call({:set, key, value}, _from, %{entries: entries} = state) do
    Entry.upsert(key, value)

    entries = Map.put(entries, key, value)

    notify_subscribers(state.callbacks, {:updated, key, value})

    {:reply, :ok, Map.put(state, :entries, entries)}
  end

  def handle_call({:get, key}, _from, %{entries: entries} = state) do
    reply = if Map.has_key?(entries, key) do
      {:ok, Map.get(entries, key)}
    else
      {:error, :no_key}
    end
    {:reply, reply, state}
  end

  def handle_call(:keys, _from, %{entries: entries} = state) do
    keys = Map.keys(entries)
    {:reply, keys, state}
  end

  def handle_call({:delete, key}, _from, %{entries: entries} = state) do

    {reply, new_state} = if Map.has_key?(entries, key) do
      Entry.delete(key)
      {key, entries} = Map.pop(entries, key)

      notify_subscribers(state.callbacks, {:deleted, key})

      {{:ok, key}, Map.put(state, :entries, entries)}
    else
      {{:error, :no_key}, state}
    end
    {:reply, reply, new_state}
  end

  def handle_call({:add_callback, module, function, args}, _from, state) do
    new_state = Map.update!(state, :entries, fn entries -> [[module, function, args] | entries] end)
    {:reply, :ok, new_state}
  end

  defp notify_subscribers(callbacks, message) do
    Enum.each(callbacks, fn [module, function, args] ->
      try do
        apply(module, function, args ++ [message])
      rescue
        _ -> :ok
      end
    end)
  end
end
