defmodule Example_Application do
	use Application

  def start(_start_type, _start_args) do
    Supervisor.start_link(
      [
        {Registry, keys: :unique, name: Example.Repository.Registry},
        {Example.DemoRepository, name: Example.DemoRepository}
      ],
      strategy: :one_for_one,
      name: Example.Supervisor
    )
  end
end
