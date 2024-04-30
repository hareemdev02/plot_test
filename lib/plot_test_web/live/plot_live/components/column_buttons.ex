defmodule PlotTestWeb.PlotLive.Components.ColumnButtons do
  use Phoenix.Component
  import PlotTestWeb.CoreComponents

  attr(:columns, :any)
  attr(:parent_target, :any)

  def column_buttons(assigns) do
    ~H"""
    <div :for={column <- @columns} class="btn-group">
      <.button
        type="button"
        class="bg-gray-500 hover:bg-gray-400 text-gray-800 font-bold rounded column-name"
        phx-value-input={column}
        phx-click="add_to_string"
        phx-target={@parent_target}
      >
        <%= column %>
      </.button>
    </div>
    """
  end
end
