defmodule RicorEx.Vnode do
  @behaviour :riak_core_vnode
  require Logger
  require Record

  Record.defrecord :riak_core_fold_req_v2, Record.extract(:riak_core_fold_req_v2, from_lib: "riak_core/include/riak_core_vnode.hrl")
  Record.defrecord :state, [:partition, :table]

  def start_vnode(partition) do
    :riak_core_vnode_master.get_vnode_pid(partition, __MODULE__)
  end

  def init([partition]) do
    ets_handle = :ets.new(nil, [])
    :ets.insert(ets_handle, {:foo, [1, 2, 3]})
    :ets.insert(ets_handle, {:bar, [4, 5, 6]})
    {:ok, state(partition: partition, table: ets_handle)}
  end

  def handle_command(:ping, _sender, state) do
    Logger.warn("got a ping request!! woohoO!'")
    {:reply, {:pong, state(state, :partition)}, state}
  end

  def handle_command({req_id, :ping}, _sender, state) do
    Logger.warn("got a ping request!! woohoO!'")
    {:reply, {req_id, {:pong, state(state, :partition)}}, state}
  end

  def handle_command(message, _sender, state) do
    Logger.warn("weird command? #{inspect([message, state])}")
    {:reply, {:pong, state(state, :partition)}, state}
  end

  def handle_handoff_command(riak_core_fold_req_v2(foldfun: visit_fun, acc0: acc0)=_fold_req, _sender, state(table: ets_handle)=state) do
    fold_fn = fn(object, acc_in) ->
      Logger.warn("folding over thing: #{inspect object}")
      acc_out = visit_fun.({:foo_bucket, object}, object, acc_in)
      Logger.warn("what is my acc out? #{inspect acc_out}")
      acc_out
    end
    final = :ets.foldl(fold_fn, acc0, ets_handle)
    {:reply, final, state}
  end

  def handoff_starting(_target_node, state) do
    Logger.warn("starting handoff! #{inspect(state)}")
    {true, state}
  end

  def handoff_cancelled(state) do
    Logger.warn("handoff cancelled :( #{inspect(state)}")
    {:ok, state}
  end

  def handoff_finished(_target_node, state) do
    Logger.warn("handoff finished! #{inspect(state)}")
    {:ok, state}
  end

  def handle_handoff_data(data, state) do
    {key, value} = :erlang.binary_to_term(data)
    Logger.warn("got some handoff data: key: #{ inspect key } and value: #{ inspect value }")
    {:reply, :ok, state}
  end

  def encode_handoff_item(object_name, object_value) do
    Logger.warn("encoding a handoff item#{inspect([object_name, object_value])}")
    :erlang.term_to_binary({object_name, object_value})
  end

  def is_empty(state(table: ets_handle)=state) do
    Logger.warn("checking for emptiness")
    {:"$end_of_table" === :ets.first(ets_handle), state}
  end

  def delete(state) do
    Logger.warn("delete the vnode")
    {:ok, state}
  end

  def handle_coverage(req, key_spaces, sender, state) do
    Logger.warn("handle coverage #{inspect([req, key_spaces, sender, state])}")
    {:stop, :not_implemented, state}
  end

  def handle_exit(pid, reason, state) do
    Logger.warn("handle exit #{inspect([pid, reason, state])}")
    {:noreply, state}
  end

  def terminate(reason, state) do
    Logger.warn("terminate #{inspect([reason, state])}")
    :ok
  end
end
