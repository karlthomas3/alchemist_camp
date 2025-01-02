filename =
  IO.gets("File to count from: ")
  |> String.trim()

count_type =
  IO.gets("words, characters, or lines? ")
  |> String.trim()

count =
  case count_type do
    "words" ->
      File.read!(filename)
      |> String.split(~r{(\\n|[^\w'])+}, trim: true)

    "lines" ->
      File.read!(filename)
      |> String.split("\n")

    "characters" ->
      File.read!(filename)
      |> String.graphemes()

    _ ->
      IO.puts("must choose words, characters, or lines")
      System.halt(1)
  end

count |> Enum.count() |> IO.puts()
