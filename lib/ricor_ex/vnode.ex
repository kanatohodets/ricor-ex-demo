defmodule RicorEx.Vnode do
  require Logger
  require Record

  Record.defrecord :state, [partition: nil]

  def start_vnode(i) do
    :riak_core_vnode_master.get_vnode_pid(i, __MODULE__)
  end

  def init([partition]) do
    {:ok, state(partition: partition)}
  end

  def handle_command(:ping, _sender, state) do
    {:reply, {:pong, state(state, :partition)}, state}
  end

  def handle_command(message, _sender, state) do
    {:reply, {:pong, state(state, :partition)}, state}
  end

  def handle_handoff_command(message, _sender, state) do
    Logger.warn("unhandled command: #{inspect(message)}")
    {:noreply, state}
  end

  def handoff_starting(_target_node, state) do
    {true, state}
  end

  def handoff_cancelled(state) do
    {:ok, state}
  end

  def handoff_finished(_target_note, state) do
    {:ok, state}
  end

  def handle_handoff_data(_data, state) do
    {:reply, :ok, state}
  end

  def encode_handeoff_item(_object_name, _object_value) do
    ""
  end

  def is_empty(state) do
    {:true, state}
  end

  def delete(state) do
    {:ok, state}
  end

  def handle_coverage(_req, _key_spaces, _sender, state) do
    {:stop, :not_implemented, state}
  end

  def handle_exit(_pid, _reason, state) do
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    :ok
  end
end
