defmodule SwaggerDoc.Mixfile do
  use Mix.Project

  def project do
    [app: :swaggerdoc,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:phoenix, "~> 1.0.0"},
      {:ecto, "~> 1.0.0"},
      {:poison, "~> 1.5.0"},
      {:ex_doc, "~> 0.8.4", only: :test},
      {:earmark, "~> 0.1.17", only: :test},
      {:meck, "~> 0.8.3", only: :test},
    ]
  end
end
