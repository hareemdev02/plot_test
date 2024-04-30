defmodule PlotTest.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias PlotTest.PlotUser
  alias PlotTest.Repo

  alias PlotTest.Resources.Plot

  @doc """
  Returns the list of plots.

  ## Examples

      iex> list_plots()
      [%Plot{}, ...]

  """
  def list_plots do
    Repo.all(Plot)
  end

  def list_plots(user_id) do
    from(p in Plot, where: p.created_by_id == ^user_id) |> Repo.all()
  end

  def list_shared_plots(user_id) do
    shared_plot_ids =
      from(pu in PlotUser, where: pu.user_id == ^user_id, select: pu.plot_id) |> Repo.all()

    from(p in Plot, where: p.id in ^shared_plot_ids) |> Repo.all()
  end

  @doc """
  Gets a single plot.

  Raises `Ecto.NoResultsError` if the Plot does not exist.

  ## Examples

      iex> get_plot!(123)
      %Plot{}

      iex> get_plot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_plot!(id), do: Repo.get!(Plot, id)

  @doc """
  Creates a plot.

  ## Examples

      iex> create_plot(%{field: value})
      {:ok, %Plot{}}

      iex> create_plot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_plot(attrs \\ %{}) do
    %Plot{}
    |> Plot.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a plot.

  ## Examples

      iex> update_plot(plot, %{field: new_value})
      {:ok, %Plot{}}

      iex> update_plot(plot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_plot(%Plot{} = plot, attrs) do
    plot
    |> Plot.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a plot.

  ## Examples

      iex> delete_plot(plot)
      {:ok, %Plot{}}

      iex> delete_plot(plot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_plot(%Plot{} = plot) do
    Repo.delete(plot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking plot changes.

  ## Examples

      iex> change_plot(plot)
      %Ecto.Changeset{data: %Plot{}}

  """
  def change_plot(%Plot{} = plot, attrs \\ %{}) do
    Plot.changeset(plot, attrs)
  end

  def create_plot_user(user_id, plot_id) do
    %PlotUser{}
    |> PlotUser.changeset(%{user_id: user_id, plot_id: plot_id})
    |> Repo.insert()
  end

  def delete_plot_user(user_id, plot_id) do
    from(pu in PlotUser, where: pu.user_id == ^user_id, where: pu.plot_id == ^plot_id)
    |> Repo.delete_all()
  end

  def get_all_plot_users(plot_id) do
    from(pu in PlotUser, where: pu.plot_id == ^plot_id, select: pu.user_id)
    |> Repo.all()
  end
end
