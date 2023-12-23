defmodule Bizard.MixProject do
  use Mix.Project

  def project do
    [
      app: :bizard,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Bizard.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.6.1"}
    ]
  end
end
