defmodule YDToolkit do
  @moduledoc """
  Yet another __Domain-Driven Design__ toolkit.
  """

  defmacro factory(name, block) do
    quote do
      defmodule unquote(name) do
        unquote(block)
      end
    end
  end

  defmacro repository(name, block) do
    quote do
      defmodule unquote(name) do
        use GenServer

        @type entry :: {__MODULE__, Registry.key}

        def start_link(opts), do: GenServer.start_link(__MODULE__, [], name: Keyword.get(opts, :name, __MODULE__))

        def registry(repository), do: GenServer.call(repository, {:get, :registry}) |> elem(1)

        @impl true
        def init(_opts) do
          registry = __MODULE__.Registry
          {:ok, _} = Registry.start_link(keys: :unique, name: registry)
          {:ok, %{registry: registry}}
        end

        @impl true
        def handle_call(request, from, state)

        def handle_call({:get, :registry}, _from, %{registry: registry} = state) do
          {:reply, {:ok, registry}, state}
        end

        def handle_call({:put_entry, key, value}, _from, %{registry: registry} = state) do
          case Registry.register(registry, key, value) do
            {:ok, _} -> :ok
            {:error, {:already_registered, _}} -> {:error, :dup}
          end
          |> then(&({:reply, &1, state}))
        end

        def handle_call(request, _from, state), do: {:reply, {:bare, request}, state}

        unquote(block)
      end
    end
  end

  defmacro value_object(name, block) do
	  quote do
      defmodule unquote(name) do
        unquote(block)
      end
    end
  end

  defmacro accessor(name, block) do
    quote do
      def unquote(name) do
        unquote(Keyword.get(block, :do))
      end
    end
  end

  defmacro constructor(name, block), do: quote do: accessor(unquote(name), unquote(block))
  defmacro setter(name, block), do: quote do: accessor(unquote(name), unquote(block))
  defmacro getter(name, block), do: quote do: accessor(unquote(name), unquote(block))

end
