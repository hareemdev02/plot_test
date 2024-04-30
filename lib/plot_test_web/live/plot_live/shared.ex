defmodule PlotTestWeb.PlotLive.Shared do
  use PlotTestWeb, :live_view

  alias PlotTest.Resources

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :plots, Resources.list_shared_plots(socket.assigns.current_user.id))}
  end
end
