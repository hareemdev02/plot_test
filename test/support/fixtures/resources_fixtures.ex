defmodule PlotTest.ResourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PlotTest.Resources` context.
  """

  @doc """
  Generate a plot.
  """
  def plot_fixture(attrs \\ %{}) do
    {:ok, plot} =
      attrs
      |> Enum.into(%{
        dataset: "some dataset",
        expression: "some expression",
        name: "some name"
      })
      |> PlotTest.Resources.create_plot()

    plot
  end
end
