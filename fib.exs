defmodule Fib do
  def fib(0), do: 0
  def fib(1), do: 1

  def fib(num) do
    fib(num - 1) + fib(num - 2)
  end
end

IO.puts(Fib.fib(45))
