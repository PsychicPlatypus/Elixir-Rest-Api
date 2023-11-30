# RestApi

A REST-ful api server built in elixir with plug cowboy. Connected to a SQLite database.

## Setting up the database

The server runs on SQLite3, using the Depo adapter.
There is a prebuild mix tasks that both creates and populates the database for you:

```ex
mix setup_db
```

## Running

Before running the server make sure that the dependencies are met:

```ex
mix deps.get
```

Now you can either run it with an iex session attached or with `mix.run`

```ex
# With iex session: good for development
iex -S mix

# Just the server:
mix run --no-halt
```
