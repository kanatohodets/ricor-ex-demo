defmodule RicorEx.Sup do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [name: __MODULE__])
  end

  def init(_args) do
    # riak_core appends _master to 'RicorEx.Vnode'
    vmaster = { RicorEx.Vnode_master,
      { :riak_core_vnode_master, :start_link, [RicorEx.Vnode] },
      :permanent, 5000, :worker, [:riak_core_vnode_master] }

    {:ok, { {:one_for_one, 5, 10 },
        [vmaster]}}
  end
end
