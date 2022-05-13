defmodule Example.Demo do

  use TypedStruct

  typedstruct do
    field :demo_1, :string, enforce: true
    field :demo_2, :integer, default: -1
  end



  alias Example.DemoRepository
  alias Example.DemoFactory
  alias YDToolkit.Stereotype.ValueObject

  @type demo_struct :: ValueObject.t



  @spec create_demo(:string, :integer) :: demo_struct() | nil

  def create_demo(demo_1, demo_2) do
    %__MODULE__{
      demo_1: demo_1,
      demo_2: demo_2
    }
    |> DemoRepository.create()
    |> maybe_create_value_object()
  end

  def maybe_create_value_object({:error, _} = term) do
    require Logger
    Logger.error("#{inspect term}")
    nil
  end
  def maybe_create_value_object({:ok, entry}) do
    DemoFactory.create(entry)
  end


end
