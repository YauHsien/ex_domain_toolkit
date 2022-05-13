import YDToolkit



repository Example.DemoRepository do
  alias YDToolkit.Stereotype.Repository

  @type created :: {:ok, Repository.entry()} | {:error, term()}

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
