defmodule SwaggerDoc.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :swaggerdoc,
      version: @version,
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      description: description,
      package: package,
      docs: [
        readme: "README.md",
        main: "README",
        source_url: "https://github.com/OpenAperture/swaggerdoc",
        #source_ref: "v#{@version}"
      ],
      name: "swaggerdoc",
      source_url: "https://github.com/OpenAperture/swaggerdoc",
      homepage_url: "https://openaperture.io/"
   ]
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
      {:phoenix, ">= 1.0.0"},
      {:ecto, ">= 1.0.0"},
      {:poison, "~> 1.5.0"},
      {:ex_doc, "~> 0.8.4", only: :docs},
      {:earmark, "~> 0.1.17", only: :docs},
      {:meck, "~> 0.8.3", only: :test},
    ]
  end

  defp description do
    "The SwaggerDoc module provides a convenience task for generating Swagger API documentation for Phoenix and Ecto-based projects."
  end

  defp package do
    [
      contributors: ["Matt Sawka"],
      licenses: ["MPL 2.0"],
      links: %{"GitHub" => "https://github.com/OpenAperture/swaggerdoc.git"},
      files:  ~w(lib) ++
              ~w(LICENSE mix.exs README.md)
    ]
  end  
end
