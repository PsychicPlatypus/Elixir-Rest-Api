defmodule RestApi.Domain.Database do
  alias Depo

  def get_book(opts \\ []) do
    extract_query_params(opts)
    |> case do
      %{query: [], variables: []} ->
        {:ok, db} = Depo.open("db.sqlite3")
        book = Depo.read(db, "SELECT * FROM books LIMIT 1;")
        Depo.close(db)
        book

      %{query: query, variables: vars} ->
        query_str = query |> Enum.join(" AND ") |> tap(&IO.inspect(&1, label: "as"))

        {:ok, db} = Depo.open("db.sqlite3")
        book = Depo.read(db, "SELECT * FROM books WHERE " <> query_str <> ";", vars)
        Depo.close(db)
        book
    end
  end

  def get_all_books() do
    {:ok, db} = Depo.open("db.sqlite3")
    books = Depo.read(db, "SELECT * FROM books;")
    Depo.close(db)

    books
  end

  @spec extract_query_params(keyword()) :: %{variables: list(String.t()), query: list(String.t())}
  def extract_query_params(keywords \\ []) do
    [
      {:name, Keyword.get(keywords, :name)},
      {:date, Keyword.get(keywords, :date)},
      {:author, Keyword.get(keywords, :author)},
      {:genre, Keyword.get(keywords, :genre)}
    ]
    |> Enum.filter(fn
      {_, nil} -> false
      _ -> true
    end)
    |> Enum.map(fn {atom, variable} ->
      {Atom.to_string(atom) <> " = ?", variable}
    end)
    |> Enum.reduce(
      %{query: [], variables: []},
      fn {query, variable}, %{query: query_, variables: variables_} ->
        %{
          query: List.insert_at(query_, 0, query),
          variables: List.insert_at(variables_, 0, variable)
        }
      end
    )
  end
end
