use Mix.Config

# Configure your database
config :memo, Memo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "memo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
