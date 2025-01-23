defmodule WordCount do
  def start(parsed, file, invalid) do
    if invalid != [] or file == "h" do
      show_help()
    else
      read_file(parsed, file)
    end
  end

  def show_help() do
    IO.puts("""
    Usage: word_count file [options]

    Options:
      -w, --words      Count words
      -c, --chars      Count characters
      -l, --lines      Count lines
      -h, --help       Show this help message
    """)
  end

  def read_file(parsed, filename) do
    flags =
      case Enum.count(parsed) do
        0 -> [:words]
        _ -> Enum.map(parsed, &elem(&1, 0))
      end

    IO.inspect(flags)

    body = File.read!(filename)
    lines = String.split(body, ~r{(\r\n|\r|\n)}, trim: true)
    words = String.split(body, ~r{(\\n|[^\w'])+}, trim: true)
    chars = String.graphemes(body)

    Enum.each(flags, fn flag ->
      case flag do
        :lines -> IO.puts("Lines: #{Enum.count(lines)}")
        :words -> IO.puts("Words: #{Enum.count(words)}")
        :chars -> IO.puts("Characters: #{Enum.count(chars)}")
        _ -> nil
      end
    end)
  end
end
