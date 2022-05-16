# YDToolkit
. . . a _Domain-Driven Design_ toolkit.

## Installation and Configuration

Add `ex_domain_toolkit` to your list of dependencies in `mix.exs`:

For example:

```elixir
{:ex_domain_toolkit, ">= 0.1.0", github: "YauHsien/ex_domain_toolkit", branch: "main"}
```

In `config/config.exs`, put configuration of registry for repository,

```elixir
import Config

config :ex_domain_toolkit, :registries,
  for_repository: MyRepoRegistry
```

Then note about its usage as what descripted as followings.

## Repository

To define a repository, you may want to code a snippet as:

```elixir
import YDToolkit

repository MyRepository do
  alias YDToolkit.Stereotype.Repository

  @spec create(struct()) ::
          {:ok, Repository.entry()} |
          {:error, term()}
  getter create(init_struct) do
    entry_key = encode(init_struct.id)
    case GenServer.call(__MODULE__, {:put_entry, entry_key, init_struct}) do
      :ok ->
        {:ok, {__MODULE__, entry_key}}
      other -> other
    end
  end
  
  defp encode(x), do: x
end
```

Repository is a `GenServer` in essence, and it keeps track set of ValueObjects
and Entities. Repository operations is based on `Repository.entry()`.

To make a repository work, an application need bring things up.

```elixir
defmodule Example.Application do
  use Application
  
  def start(_start_type, _start_args) do
    Supervisor.start_link(
      [
        {Registry, keys: :unique, name: MyRepoRegistry},
        {MyRepository, name: MyRepo}
      ],
      strategy: :one_for_one,
      name: Example.Supervisor
    )
  end
end
```

Note that when you have an alias `MyRepoRegistry` for registry of repository
in `config/config.exs`, your application need start a registry of that name
first. Then repositories following up including the repository `MyRepository`
use the registry for itself to be kept in the supervisor tree.

## Value Object

To define a value object, the code may be like that:

```elixir
import YDToolkit

value_object MyValueObject do
  alias MyRepository
  
  use TypedStruct
  typedstruct do
    field :repository, :atom, enforce: true
    field :entry_key, Registry.key, enforce: true
  end
  
  @sepc create(Repository.entry) :: t
  
  constructor create({repo, key}) do
    %__MODULE__{
      repository: repo,
      entry_key: key
    }
  end
end
```

A value object is defined as some object kept track in a repository, and thus
you will be able to query it from a repository by using a `Registry.entry`
which has the repository name and the registry key of that value object.

## Factory

A Factory is a module which is to build structures.

```elixir
import YDToolkit

factory MyFactory do
  alias MyRepository
  alias MyValueObject
  
  @spec create(MyRepository.entry) :: t
  
  value_object create({_repo, _key} = entry) do
    MyValueObject.create(entry)
  end
end
```
