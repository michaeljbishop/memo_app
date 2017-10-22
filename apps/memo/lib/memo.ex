defmodule Memo do
  use GenServer
  require Logger
  
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
  
  
  # === Server ===
  
  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end
  
  def init(:ok) do
    Logger.debug "Started Memo"
    state = %{}
    {:ok, state}
  end
  
  def handle_call(:all, _from, state) do
    {:reply, {:ok, state}, state}
  end
  
  def handle_call({:set, key, value}, _from, state) do
    new_state = Map.put(state, key, value)
    {:reply, :ok, new_state}
  end
  
  def handle_call({:get, key}, _from, state) do
    reply =
      if Map.has_key?(state, key) do
        {:ok, Map.get(state, key)}
      else
        {:error, :no_key}
      end
    {:reply, reply, state}
  end

  def handle_call(:keys, _from, state) do
    keys = Map.keys(state)
    {:reply, keys, state}
  end
  
  def handle_call({:delete, key}, _from, state) do
    {reply, new_state} =
      if Map.has_key?(state, key) do
        {{:ok, Map.get(state, key)}, Map.delete(state, key)}
      else
        {{:error, :no_key}, state}
      end
    {:reply, reply, new_state}
  end
end
