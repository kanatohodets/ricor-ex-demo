defmodule RicorEx do
  require Record
  require Logger
  Record.extract_all(from_lib: "riak_core/include/riak_core_vnode.hrl")
  def ping do
    doc_idx = :riak_core_util.chash_key({"ping", :erlang.term_to_binary(:os.timestamp())})
    pref_list = :riak_core_apl.get_primary_apl(doc_idx, 1, RicorEx)
    Logger.warn("pref list: #{inspect(pref_list)}")
    [{index_node, _type}] = pref_list
    # riak core appends "_master" to RicorEx.Vnode.
    :riak_core_vnode_master.sync_spawn_command(index_node, :ping, RicorEx.Vnode_master)
  end
end
