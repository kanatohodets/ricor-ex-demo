defmodule RicorEx.Service do
  require Record
  Record.extract_all(from_lib: "riak_core/include/riak_core_vnode.hrl")
  def ping do
    doc_idx = :riak_core_util.chash_key({"ping", :erlang.term_to_binary(:os.timestamp())})
    pref_list = :riak_core_apl.get_primary_apl(doc_idx, 1, :ricor)
    [{index_node, _type}] = pref_list
    # RicorEx.VnodeMaster is the process name from RicorEx.Sup
    :riak_core_vnode_master.sync_spawn_command(index_node, :ping, RicorEx.VnodeMaster)
  end
end
