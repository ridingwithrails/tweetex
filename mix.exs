defmodule Tweetex.MixProject do
  use Mix.Project

  def project do
    [
      app: :tweetex,
      version: "0.1.0",
      elixir: "~> 1.8",
      escript: [main_module: Tweetex],        
      # start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end
# Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:poison, "~> 3.1"},
      {:oauther, "~> 1.1"},
      {:mime, "~> 1.2"},
      {:mox, "~> 0.5", only: :test}      
    ]
  end
end
# TODO: https://asquera.de/blog/2015-04-10/writing-a-commandline-app-in-elixir/