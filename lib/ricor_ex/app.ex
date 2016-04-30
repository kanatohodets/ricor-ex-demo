defmodule RicorEx.App do
  use Application
  require Logger

  def start(_type, _args) do
    case RicorEx.Sup.start_link() do
      {:ok, pid} ->
        :ok = :riak_core.register([{:vnode_module, RicorEx.Vnode}])
        :ok = :riak_core_node_watcher.service_up(RicorEx.Service, self())
        {:ok, pid}
      {:error, reason} ->
        Logger.error("omg error while starting app: #{inspect(reason)}")
        {:error, reason}
    end
  end
end


