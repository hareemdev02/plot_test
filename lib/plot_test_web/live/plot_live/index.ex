defmodule PlotTestWeb.PlotLive.Index do
  use PlotTestWeb, :live_view

  alias PlotTest.Resources
  alias PlotTest.Resources.Plot

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :plots, Resources.list_plots(socket.assigns.current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Plot")
    |> assign(:plot, Resources.get_plot!(id))
  end

  defp apply_action(socket, :share, %{"id" => id}) do
    socket
    |> assign(:page_title, "Share to others")
    |> assign(:plot, Resources.get_plot!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Plot")
    |> assign(:plot, %Plot{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Plots")
    |> assign(:plot, nil)
  end

  @impl true
  def handle_info({PlotTestWeb.PlotLive.FormComponent, {:saved, plot}}, socket) do
    {:noreply, stream_insert(socket, :plots, plot)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    plot = Resources.get_plot!(id)
    {:ok, _} = Resources.delete_plot(plot)

    {:noreply, stream_delete(socket, :plots, plot)}
  end
end
