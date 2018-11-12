defmodule ArtifactDeckCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :artifact_deck_code,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Encoder and decoder for Artifact decks.",
      package: package(),
      source_url: "https://github.com/Kabie/artifact_deck_code"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Kabie/artifact_deck_code"}
    ]
  end
end
