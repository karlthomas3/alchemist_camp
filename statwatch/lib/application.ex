defmodule Statwatch.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Statwatch.Scheduler, []}
    ]

    opts = [strategy: :one_for_one, name: Statwatch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
