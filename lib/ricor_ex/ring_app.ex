defmodule PhoenixRicor.RingApp do
  use Application

  def start(_type, _args) do
    case PhoenixRicor.VnodeMaster.start_link() do
      {:ok, pid} ->
        :ok = :riak_core.register([{:vnode_module, PhoenixRicor.Vnode}])
        :ok = :riak_core_node_watcher.service_up(PhoenixRicor.Thing, self())
        {:ok, pid}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def stop(_state) do
    :ok
  end
end
