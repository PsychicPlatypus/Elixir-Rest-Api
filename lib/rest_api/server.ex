defmodule RestApi.Server do
  use Plug.Router
  alias RestApi.Domain.Database

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/book/:name" do
    book = Database.get_book(name: name)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(book))
  end

  get "/book" do
    book = Database.get_book(convert_to_klist(conn.query_params))

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(book))
  end

  get "/books" do
    books = Database.get_all_books()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(books))
  end

  match _ do
    conn
    |> send_resp(404, "Not Found, available routes: /book, /book/:name, /books")
  end

  defp convert_to_klist(map) do
    Enum.map(
      map,
      fn {key, value} -> {String.to_existing_atom(key), value} end
    )
  rescue
    _ ->
      []
  end
end
