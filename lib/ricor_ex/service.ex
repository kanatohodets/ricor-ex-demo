defmodule RicorEx.Service do
  require Record
  require Logger
  Record.extract_all(from_lib: "riak_core/include/riak_core_vnode.hrl")
  def ping do
    doc_idx = :riak_core_util.chash_key({"ping", :erlang.term_to_binary(:os.timestamp())})
    pref_list = :riak_core_apl.get_primary_apl(doc_idx, 1, RicorEx.Service)
    Logger.warn("pref list: #{inspect(pref_list)}")
    [{index_node, _type}] = pref_list
    # riak core appends "_master" to RicorEx.Vnode.
    :riak_core_vnode_master.sync_spawn_command(index_node, :ping, RicorEx.Vnode_master)
  end

  def ping_n(n) do
    w = n - 1
    key = {"ping", :erlang.term_to_binary(:os.timestamp())}
    {:ok, req_id} = RicorEx.OpFSM.op(:ping, key, n, w)
    wait_for_reqid(req_id, 5000)
  end

  defp wait_for_reqid(req_id, timeout) do
    receive do
      {^req_id, value} ->
        {:ok, value}
    after
      timeout ->
        {:error, :timeout}
    end
  end
end
