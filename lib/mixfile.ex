defmodule Blockbox.Mixfile do
  use Mix.Project

  def project do
    [app: :blockbox,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package() ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README", "LICENSE*"],
      maintainers: ["Samar Sajnani"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/azohra/BlockBox"}
    ]
  end
end
