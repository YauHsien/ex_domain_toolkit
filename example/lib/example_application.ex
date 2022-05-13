defmodule Example_Application do
	use Application

  def start(_start_type, _start_args) do
    Supervisor.start_link(
      [
        {Example.DemoRepository, name: Example.DemoRepository}
      ],
      strategy: :one_for_one,
      name: Example_Application
    )
  end
end
