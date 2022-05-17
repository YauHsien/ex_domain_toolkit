import YDToolkit


aggregate Example.ShippingModule.CargoAggregate do
  alias Example.ShippingModule.CargoAggregateRepository

  @type created :: {:ok, entry()} | {:error, term()}

  @spec       create(Cargo.t) :: created()
  constructor create(init_struct) do
    #TODO: need save, then there is a field `id` in `init_struct`,
    entry_name = {CargoAggregateRepository, encode(init_struct.id)}
    case start_link(init_struct: init_struct, name: {:via, Registry, entry_name}) do
      {:ok, _} -> {:ok, entry_name}
      _other -> {:error, :failed_start}
    end
  end

  defp encode(x), do: x

end

entity Example.ShippingModule.Cargo do
  alias Example.ShippingModule.Cargo
  alias Example.ShippingModule.CargoAggregate
  alias Example.ShippingModule.CargoAggregateRepository
  alias Example.ShippingModule.DeliveryHistory

  @type delivery_history_entry :: {CargoAggregate.entry, Registry.key}

  use TypedStruct
  typedstruct do
    field :id, :integer, enforce: true
    field :delivery_history, delivery_history_entry(), enforce: true
    field :customer_roles, Keyword.t, default: []
  end

  @spec get_aggregate_entry(Cargo.t) :: {CargoAggregateRepository, Registry.key}
  def get_aggregate_entry(cargo), do: {CargoAggregateRepository, build_key(cargo.id)}

  @spec get_delivery_history(Cargo.t) :: DeliveryHistory.t
  def get_delivery_history(cargo) do
    cargo
    |> get_aggregate_entry()
    |> CargoAggregateRepository.get_aggregate()
    |> CargoAggregate.get_delivery_history()
  end

  @spec set_delivery_history(Cargo.t, DeliveryHistory.t) :: Cargo.t
  def set_delivery_history(cargo, history) do
    history
    |> DeliveryHistory.set_cargo(cargo)
    |> then(&(
          %Cargo{cargo |
                 delivery_history:
                 {{CargoAggregateRepository, build_key(cargo.id)},
                  build_key(&1.id)}
          } ))
  end

  defp build_key(nil), do: nil
  defp build_key(x), do: {__MODULE__, x}

end

entity Example.ShippingModule.DeliveryHistory do
  alias Example.ShippingModule.CargoAggregate
  alias Example.ShippingModule.DeliveryHistory

  @type cargo_entry :: {CargoAggregate.entry, Registry.key}

  use TypedStruct
  typedstruct do
    field :id, :integer, enforce: true
    field :cargo, cargo_entry()
  end

  def set_cargo(history, cargo),
    do: %DeliveryHistory{history |
                         cargo:
                         {{CargoAggregateRepository, build_key(cargo.id)},
                          build_key(cargo.id)}}

  defp build_key(x), do: nil
  defp build_key(x), do: {__MODULE__, x}

end

factory Example.ShippingModule.CargoAggregateFactory do
  alias Example.ShippingModule.Cargo
  alias Example.ShippingModule.CargoAggregateRepository
  alias Example.ShippingModule.DeliveryHistory

  @spec  build_cargo_aggregate(Cargo.t, DeliveryHistory.t) :: {CargoAggregateRepository, Registry.key}
  getter build_cargo_aggregate(cargo, history) do
    entry_name = {CargoAggregateRepository, build_key(cargo.id)}
    cargo_1 = %Cargo{cargo | delivery_history: {CargoAggregateRepository, build_key(history.id)}}
    history_1 = %DeliveryHistory{history | cargo: entry_name}
    entry_name
  end

  defp build_key(x), do: :"#{inspect x}"

end

repository Example.ShippingModule.CargoAggregateRepository do

  @type created :: {:ok, entry()} | {:error, term()}

  @spec create(Example.Demo.t) :: created()

  accessor create(demo_struct) do
    #TODO: need save..., then suppose an identity `1` was given,
    entry_key = encode(demo_struct.demo_2)
    case GenServer.call(__MODULE__, {:put_entry, entry_key, demo_struct}) do
      :ok ->
        #TODO: here you may want to have another registry entry, and then...
        {:ok, {__MODULE__, entry_key}}
      other -> other
    end
  end

  defp encode(x), do: x

end
