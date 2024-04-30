defmodule PlotTestWeb.PlotLive.Components.Share do
  alias PlotTest.Resources
  alias PlotTest.Accounts
  use PlotTestWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to share the plot with other users.</:subtitle>
      </.header>
      <.simple_form :let={f} for={%{}} id="plot-user-form">
        <.input field={f[:plot_id]} value={@plot.id} type="hidden" />
        <span :for={user <- @users} class="flex justify-between">
          <%= user.email %>
          <.button
            :if={user.id not in @users_shared}
            class="ml-4"
            phx-target={@myself}
            phx-click="share"
            phx-value-id={user.id}
            phx-disable-with="Saving..."
          >
            Share Plot
          </.button>
          <.button
            :if={user.id in @users_shared}
            class="ml-4"
            phx-target={@myself}
            phx-click="unshare"
            phx-value-id={user.id}
            phx-disable-with="Saving..."
          >
            Unshare
          </.button>
        </span>
      </.simple_form>
    </div>
    """
  end

  def update(assigns, socket) do
    users = Accounts.list_users() |> Enum.reject(&(&1.id == assigns.current_user.id))
    users_shared = Resources.get_all_plot_users(assigns.plot.id)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(users: users)
     |> assign(users_shared: users_shared)}
  end

  def handle_event("share", %{"id" => id}, socket) do
    Resources.create_plot_user(id, socket.assigns.plot.id)
    users_shared = Resources.get_all_plot_users(socket.assigns.plot.id)

    {:noreply,
     socket
     |> assign(users_shared: users_shared)
     |> put_flash(:info, "Plot shared successfully")
     |> push_patch(to: socket.assigns.patch)}
  end

  def handle_event("unshare", %{"id" => id}, socket) do
    Resources.delete_plot_user(id, socket.assigns.plot.id)
    users_shared = Resources.get_all_plot_users(socket.assigns.plot.id)

    {:noreply,
     socket
     |> assign(users_shared: users_shared)
     |> put_flash(:info, "Plot unshared successfully")
     |> push_patch(to: socket.assigns.patch)}
  end
end
