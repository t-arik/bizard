defmodule Bizard.MixProject do
  use Mix.Project

  def project do
    [
      app: :bizard,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: ["bizard", "bizard.ex", "component", "controller", "plug", "views"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Bizard, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.6.1"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
    ]
  end
end
