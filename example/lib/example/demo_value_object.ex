import YDToolkit



value_object Example.DemoValueObject do

  alias Example.DemoRepository


  use TypedStruct

  typedstruct do
    field :repository, :atom, enforce: true
    field :entry_key, Registry.key, enforce: true
  end



  @spec create(DemoRepository.entry) :: t

  constructor create({repository, entry_key}) do
    %__MODULE__{
      repository: repository,
      entry_key: entry_key
    }
  end

end
