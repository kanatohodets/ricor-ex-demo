defmodule RicorEx.Sup do
  use Supervisor

  def start_link do
    # riak_core appends _sup to the application name.
    Supervisor.start_link(__MODULE__, [], [name: RicorEx_sup])
  end

  def init(_args) do
    # riak_core appends _master to 'RicorEx.Vnode'
    children = [
      worker(:riak_core_vnode_master, [RicorEx.Vnode], name: RicorEx.Vnode_master)
    ]
    supervise(children, strategy: :one_for_one, max_restarts: 5, max_seconds: 10)
  end
end
