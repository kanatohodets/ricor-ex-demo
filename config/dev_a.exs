use Mix.Config

config :riak_core,
  web_port: 8098,
  handoff_port: 8099,
  ring_state_dir: 'ring_data_dir_a',
  platform_data_dir: 'data_a',
  # TODO: wtf...
  schema_dirs: ['/Users/btyler/personal/prog/elixir/ricor_ex/_build/dev_a/lib/riak_core/priv']
