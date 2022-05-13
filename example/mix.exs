defmodule Example.MixProject do
  use Mix.Project

  def project do
    [
      app: :example,
      version: "1.0.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Example_Application, []}
    ]
  end

  defp deps do
    [
      {:ex_domain_toolkit, path: ".."},
      {:typed_struct, "~> 0.1.4"}
    ]
  end
end
