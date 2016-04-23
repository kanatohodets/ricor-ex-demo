defmodule RicorEx do
  use Application

  def start(_type, _args) do
    case RicorEx.Sup.start_link() do
      {:ok, pid} ->
        :ok = :riak_core.register([{:vnode_module, RicorEx.Vnode}])
        :ok = :riak_core_node_watcher.service_up(RicorEx.Service, self())
        {:ok, pid}
      {:error, reason} ->
        {:error, reason}
    end
  end
end


