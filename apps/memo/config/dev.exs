use Mix.Config

# Configure your database
config :memo, Memo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "memo_dev",
  hostname: "localhost",
  pool_size: 10
