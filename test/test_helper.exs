ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Msqh.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Msqh.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Msqh.Repo)

