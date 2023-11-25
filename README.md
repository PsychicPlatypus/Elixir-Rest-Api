# RestApi

A REST-ful api server built in elixir with plug cowboy. Connected to a SQLite database.

## Running

Before running the server make sure that the dependencies are met:

```zsh
mix deps.get
```

Now you can either run it with an iex session attached or with `mix.run`

```zsh
# With iex session: good for development
iex -S mix

# Just the server:
mix run --no-halt
```
