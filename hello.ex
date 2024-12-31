defmodule Hello do
  def name() do
    n = IO.gets("What's your name? ")
    name = String.trim(n)

    case name do
      "" ->
        IO.puts("No need to be shy!")
        name()

      "karl" ->
        IO.puts("Kaaaaaaarrrll! That KILLLS people!")

      _ ->
        IO.puts("Hello, #{name}!")
    end
  end
end
