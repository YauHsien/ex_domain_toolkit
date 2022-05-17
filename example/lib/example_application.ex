defmodule Example_Application do
	use Application

  def start(_start_type, _start_args) do

    registry_name = Application.fetch_env!(:ex_domain_toolkit, :registry)

    Supervisor.start_link(
      [
        {Registry, keys: :unique, name: registry_name},
        {Example.DemoRepository, name: Example.DemoRepository},
        {Example.ShippingModule.CargoAggregateRepository, name: Example.ShippingModule.CargoAggregateRepository}
      ],
      strategy: :one_for_one,
      name: Example.Supervisor
    )
  end
end
