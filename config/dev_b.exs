use Mix.Config

config :riak_core,
  web_port: 8198,
  handoff_port: 8199,
  ring_state_dir: 'ring_data_dir_b',
  platform_data_dir: 'data_b',
  # TODO: wtf...
  schema_dirs: ['/Users/btyler/personal/prog/elixir/ricor_ex/_build/dev_b/lib/riak_core/priv']
