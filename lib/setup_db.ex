defmodule Mix.Tasks.SetupDb do
  @moduledoc "The setup_db mix task: `mix help setup_db`"

  alias Depo
  use Mix.Task

  @shortdoc "Sets up database or creates the database file if it doesn't exist"
  def run(_) do
    setup_db()
  end

  defp setup_db() do
    if File.exists?("db.sqlite3") do
      Mix.Task.run("app.start")
      {:ok, db} = Depo.open("db.sqlite3")

      Depo.write(
        db,
        "CREATE TABLE if not exists books (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, genre TEXT, date TEXT, author TEXT);"
      )

      [
        %{
          name: "The Lord of the Rings",
          genre: "Fantasy",
          date: "1954-07-29",
          author: "J.R.R. Tolkien"
        },
        %{
          name: "The Hobbit",
          genre: "Fantasy",
          date: "1937-09-21",
          author: "J.R.R. Tolkien"
        },
        %{
          name: "The Silmarillion",
          genre: "Fantasy",
          date: "1977-09-15",
          author: "J.R.R. Tolkien"
        },
        %{
          name: "The Chronicles of Narnia",
          genre: "Fantasy",
          date: "1950-10-16",
          author: "C.S. Lewis"
        },
        %{
          name: "The Lion, the Witch and the Wardrobe",
          genre: "Fantasy",
          date: "1950-10-16",
          author: "C.S. Lewis"
        },
        %{
          name: "The Magician's Nephew",
          genre: "Fantasy",
          date: "1955-10-16",
          author: "C.S. Lewis"
        }
      ]
      |> Enum.each(fn book ->
        Depo.write(
          db,
          """
          INSERT INTO books (name, genre, date, author) VALUES ("#{book.name}", "#{book.genre}", "#{book.date}", "#{book.author}");
          """
        )
      end)

      Depo.read(db, "SELECT * FROM books;")

      Depo.close(db)
    else
      create_file!()
    end
  end

  defp create_file!() do
    File.touch!("db.sqlite3")
    setup_db()
  end
end
