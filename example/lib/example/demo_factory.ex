import YDToolkit



factory Example.DemoFactory do

  alias Example.Demo
  alias Example.DemoRepository
  alias Example.DemoValueObject

  @spec create(DemoRepository.entry) :: Demo.struct()

  getter create({_repository, _entry_key} = entry) do
    DemoValueObject.create(entry)
  end

end
