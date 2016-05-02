defmodule RicorEx.OtherService do
  require Record
  require Logger
  Record.extract_all(from_lib: "riak_core/include/riak_core_vnode.hrl")
  def blorg do
    doc_idx = :riak_core_util.chash_key({"blorg", :erlang.term_to_binary(:os.timestamp())})
    pref_list = :riak_core_apl.get_primary_apl(doc_idx, 5, RicorEx.OtherService)
    Logger.warn("pref list: #{inspect(pref_list)}")
    [{index_node, _type}] = pref_list
    # riak core appends "_master" to RicorEx.OtherVnode.
    :riak_core_vnode_master.sync_spawn_command(index_node, :blorg, RicorEx.OtherVnode_master)
  end
end
