defmodule BlockBox.MixProject do
  use Mix.Project

  def project do
    [
      app: :blockbox,
      version: "1.2.1",
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package(),
      docs: [
        main: "BlockBox",
        logo: "images/square_shit_bricks_white.png",
        extras: ["README.md"]
      ]
    ]
  end

  defp aliases do
    [docs: ["docs", &copy_images/1]]
  end

  defp copy_images(_) do
    File.cp_r("images", "doc/images")
  end

  defp package do
    [
      description: "A tool used to generate slack UI blocks using elixir defined functions.",
      files: ["lib", "mix.exs", "README.md", "LICENSE*"],
      maintainers: ["Samar Sajnani"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/azohra/BlockBox"}
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
