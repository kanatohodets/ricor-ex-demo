defmodule RicorEx.Sup do
  use Supervisor

  def start_link do
    # riak_core appends _sup to the application name.
    Supervisor.start_link(__MODULE__, [], [name: :ricor_ex_sup])
  end

  def init(_args) do
    # riak_core appends _master to 'RicorEx.Vnode'
    children = [
      worker(:riak_core_vnode_master, [RicorEx.Vnode], name: RicorEx.Vnode_master, id: RicorEx.Vnode_master_worker),
      worker(:riak_core_vnode_master, [RicorEx.OtherVnode], name: RicorEx.OtherVnode_master, id: RicorEx.OtherVnode_master_worker)
    ]
    supervise(children, strategy: :one_for_one, max_restarts: 5, max_seconds: 10)
  end
end
