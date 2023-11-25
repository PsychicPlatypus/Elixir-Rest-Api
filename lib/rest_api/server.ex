defmodule RestApi.Server do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/book/:name" do
    IO.inspect(name)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(["stuff", "stuff", "stuff"]))
  end

  get "/book" do
    stuff = fetch_query_params(conn) |> tap(&IO.inspect(&1, label: "👍"))
    stuff |> tap(&IO.inspect(&1, label: "👍"))

    conn
    |> send_resp(200, "thank you for using apppp D:")
  end

  match _ do
    conn
    |> send_resp(404, "Not Found, available routes: #{inspect(Plug.Router.module_info())}")
  end
end
