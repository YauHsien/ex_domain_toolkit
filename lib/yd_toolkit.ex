defmodule YDToolkit do
  @moduledoc """
  Yet another *Domain-Driven Design* toolkit.
  """

  @spec factory({atom, maybe_improper_list, maybe_improper_list}, [{:do, any}, ...]) ::
          {:def, [{:context, YDToolkit} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, maybe_improper_list, maybe_improper_list}, ...]}
          | {:defmodule, [{:context, YDToolkit} | {:import, Kernel}, ...],
             [[{any, any}, ...] | {:__aliases__, maybe_improper_list, maybe_improper_list}, ...]}
  defmacro factory({:__aliases__, c, a} = name, do: block) when is_list(c) and is_list(a) do
    quote do
      defmodule unquote(name) do
        unquote(block)
      end
    end
  end

  defmacro factory({f, c, a} = name, do: block) when is_atom(f) and is_list(c) and is_list(a) do
	  quote do
      def unquote(name) do
        unquote(block)
      end
    end
  end

  @spec repository({atom, maybe_improper_list, maybe_improper_list}, [{:do, any}, ...]) ::
          {:def, [{:context, YDToolkit} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, maybe_improper_list, maybe_improper_list}, ...]}
          | {:defmodule, [{:context, YDToolkit} | {:import, Kernel}, ...],
             [[{any, any}, ...] | {:__aliases__, maybe_improper_list, maybe_improper_list}, ...]}
  defmacro repository({:__aliases__, c, a} = name, do: block) when is_list(c) and is_list(a) do
    quote do
      defmodule unquote(name) do
        use GenServer

        @type entry :: {__MODULE__, Registry.key}
        @registry Application.fetch_env!(:ex_domain_toolkit, :registry)

        def start_link(opts),
          do: GenServer.start_link(__MODULE__, [],
                name: {:via, Registry, {@registry, Keyword.get(opts, :name, __MODULE__)}})

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

        def handle_call({:get_entry, key}, _from, %{registry: registry} = state) do
          case Registry.lookup(registry, key) do
            [] -> {:error, :not_found}
            [{pid, value}] when pid == self() -> {:ok, value}
          end
          |> then(&({:reply, &1, state}))
        end

        def handle_call(request, _from, state), do: {:reply, {:bare, request}, state}

        unquote(block)
      end
    end
  end

  defmacro repository({f, c, a} = name, do: block) when is_atom(f) and is_list(c) and is_list(a) do
	  quote do
      def unquote(name) do
        unquote(block)
      end
    end
  end

  @spec aggregate({atom, maybe_improper_list, maybe_improper_list}, [{:do, any}, ...]) ::
          {:def, [{:context, YDToolkit} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, maybe_improper_list, maybe_improper_list}, ...]}
          | {:defmodule, [{:context, YDToolkit} | {:import, Kernel}, ...],
             [[{any, any}, ...] | {:__aliases__, maybe_improper_list, maybe_improper_list}, ...]}
  defmacro aggregate({:__aliases__, c, a} = name, do: block) when is_list(c) and is_list(a) do
    quote do
      defmodule unquote(name) do
        unquote(block)
      end
    end
  end

  defmacro aggregate({f, c, a} = name, do: block) when is_atom(f) and is_list(c) and is_list(a) do
	  quote do
      def unquote(name) do
        unquote(block)
      end
    end
  end

  @spec value_object({atom, maybe_improper_list, maybe_improper_list}, [{:do, any}, ...]) ::
          {:def, [{:context, YDToolkit} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, maybe_improper_list, maybe_improper_list}, ...]}
          | {:defmodule, [{:context, YDToolkit} | {:import, Kernel}, ...],
             [[{any, any}, ...] | {:__aliases__, maybe_improper_list, maybe_improper_list}, ...]}
  defmacro value_object({:__aliases__, c, a} = name, do: block) when is_list(c) and is_list(a) do
    quote do
      defmodule unquote(name) do
        unquote(block)
      end
    end
  end

  defmacro value_object({f, c, a} = name, do: block) when is_atom(f) and is_list(c) and is_list(a) do
	  quote do
      def unquote(name) do
        unquote(block)
      end
    end
  end

  @spec entity({atom, maybe_improper_list, maybe_improper_list}, [{:do, any}, ...]) ::
          {:def, [{:context, YDToolkit} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, maybe_improper_list, maybe_improper_list}, ...]}
          | {:defmodule, [{:context, YDToolkit} | {:import, Kernel}, ...],
             [[{any, any}, ...] | {:__aliases__, maybe_improper_list, maybe_improper_list}, ...]}
  defmacro entity({:__aliases__, c, a} = name, do: block) when is_list(c) and is_list(a) do
    quote do
      defmodule unquote(name) do
        unquote(block)
      end
    end
  end

  defmacro entity({f, c, a} = name, do: block) when is_atom(f) and is_list(c) and is_list(a) do
	  quote do
      def unquote(name) do
        unquote(block)
      end
    end
  end

  @spec accessor(any, [{:do, [{any, any}]}, ...]) ::
          {:def, [{:context, YDToolkit} | {:import, Kernel}, ...], [...]}
  defmacro accessor(name, do: block) do
    quote do
      def unquote(name) do
        unquote(block)
      end
    end
  end

  @spec constructor(any, any) :: {:accessor, [], [...]}
  defmacro constructor(name, block), do: quote do: accessor(unquote(name), unquote(block))
  @spec setter(any, any) :: {:accessor, [], [...]}
  defmacro setter(name, block), do: quote do: accessor(unquote(name), unquote(block))
  @spec getter(any, any) :: {:accessor, [], [...]}
  defmacro getter(name, block), do: quote do: accessor(unquote(name), unquote(block))

end
