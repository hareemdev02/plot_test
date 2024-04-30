defmodule PlotTest.ResourcesTest do
  use PlotTest.DataCase

  alias PlotTest.Resources

  describe "plots" do
    alias PlotTest.Resources.Plot

    import PlotTest.ResourcesFixtures

    @invalid_attrs %{name: nil, dataset: nil, expression: nil}

    test "list_plots/0 returns all plots" do
      plot = plot_fixture()
      assert Resources.list_plots() == [plot]
    end

    test "get_plot!/1 returns the plot with given id" do
      plot = plot_fixture()
      assert Resources.get_plot!(plot.id) == plot
    end

    test "create_plot/1 with valid data creates a plot" do
      valid_attrs = %{name: "some name", dataset: "some dataset", expression: "some expression"}

      assert {:ok, %Plot{} = plot} = Resources.create_plot(valid_attrs)
      assert plot.name == "some name"
      assert plot.dataset == "some dataset"
      assert plot.expression == "some expression"
    end

    test "create_plot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_plot(@invalid_attrs)
    end

    test "update_plot/2 with valid data updates the plot" do
      plot = plot_fixture()
      update_attrs = %{name: "some updated name", dataset: "some updated dataset", expression: "some updated expression"}

      assert {:ok, %Plot{} = plot} = Resources.update_plot(plot, update_attrs)
      assert plot.name == "some updated name"
      assert plot.dataset == "some updated dataset"
      assert plot.expression == "some updated expression"
    end

    test "update_plot/2 with invalid data returns error changeset" do
      plot = plot_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_plot(plot, @invalid_attrs)
      assert plot == Resources.get_plot!(plot.id)
    end

    test "delete_plot/1 deletes the plot" do
      plot = plot_fixture()
      assert {:ok, %Plot{}} = Resources.delete_plot(plot)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_plot!(plot.id) end
    end

    test "change_plot/1 returns a plot changeset" do
      plot = plot_fixture()
      assert %Ecto.Changeset{} = Resources.change_plot(plot)
    end
  end
end
