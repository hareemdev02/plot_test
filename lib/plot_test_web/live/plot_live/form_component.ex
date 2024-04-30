defmodule PlotTestWeb.PlotLive.FormComponent do
  use PlotTestWeb, :live_component

  alias PlotTest.CsvReader
  alias PlotTest.Resources
  alias PlotTestWeb.PlotLive.Helper

  import PlotTestWeb.PlotLive.Components.ColumnButtons

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage plot records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="plot-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:created_by_id]} type="hidden" value={@current_user.id} />
        <.input field={@form[:name]} type="text" label="Name" placeholder="Enter name" />
        <.input
          field={@form[:dataset]}
          prompt="Select a dataset"
          type="select"
          options={@options}
          label="Dataset"
        />
        <div :if={@expressions} class="container mx-auto mt-8">
          <label class="block text-sm font-semibold leading-6 text-zinc-800">Expression</label>
          <div class="flex items-center space-x-2">
            <div class="btn-group">
              <.button
                type="button"
                class="bg-gray-500 hover:bg-gray-400 text-gray-800 font-bold rounded binary-operation"
                phx-value-input="+"
                phx-click="add_to_string"
                phx-target={@myself}
              >
                +
              </.button>
              <.button
                type="button"
                class="bg-gray-500 hover:bg-gray-400 text-gray-800 font-bold rounded binary-operation"
                phx-value-input="-"
                phx-click="add_to_string"
                phx-target={@myself}
              >
                -
              </.button>
              <.button
                type="button"
                class="bg-gray-500 hover:bg-gray-400 text-gray-800 font-bold rounded binary-operation"
                phx-value-input="*"
                phx-click="add_to_string"
                phx-target={@myself}
              >
                *
              </.button>
              <.button
                type="button"
                class="bg-gray-500 hover:bg-gray-400 text-gray-800 font-bold rounded binary-operation"
                phx-value-input="/"
                phx-click="add_to_string"
                phx-target={@myself}
              >
                /
              </.button>
            </div>
          </div>
          <div class="flex items-center space-x-2 mt-2">
            <.column_buttons parent_target={@myself} columns={@expressions} />
          </div>
          <div class="mt-4 flex items-center space-x-2">
            <input
              type="text"
              id="formulaInput"
              class="border border-gray-300 rounded-md w-96"
              value={@expression_string}
              readonly
            />
            <.button
              type="button"
              class="bg-gray-500 hover:bg-gray-400 text-gray-800 font-bold rounded"
              id="clearButton"
              phx-click="clear_string"
              phx-target={@myself}
            >
              Clear
            </.button>
          </div>
          <p :if={@expression_error} class="mt-3 flex gap-3 text-sm leading-6 text-rose-600">
            <span class="hero-exclamation-circle-mini mt-0.5 h-5 w-5 flex-none"></span><%= @expression_error %>
          </p>
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save Plot</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{plot: plot} = assigns, socket) do
    changeset = Resources.change_plot(plot)

    expressions =
      if plot.expression do
        CsvReader.read_csv_and_get_column_names("priv/static/csv/#{plot.dataset}")
      else
        nil
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(options: Helper.csv_options())
     |> assign(expressions: expressions)
     |> assign(expression_string: "")
     |> assign(expression_error: nil)}
  end

  @impl true
  def handle_event("clear_string", _, socket) do
    {:noreply, assign(socket, expression_string: "")}
  end

  def handle_event("add_to_string", %{"input" => input}, socket) do
    new_string = socket.assigns.expression_string <> input

    expression_error =
      if String.match?(new_string, ~r/^[-+\/*].*|.*[-+\/*]$/) do
        "expression in invalid"
      end

    {:noreply,
     assign(socket, expression_string: new_string) |> assign(expression_error: expression_error)}
  end

  def handle_event("validate", %{"plot" => plot_params}, socket) do
    plot_params = Map.put(plot_params, "expression", socket.assigns.expression_string)

    expression_error =
      if String.match?(socket.assigns.expression_string, ~r/^[-+\/*].*|.*[-+\/*]$/) do
        "expression in invalid"
      end

    changeset =
      socket.assigns.plot
      |> Resources.change_plot(plot_params)
      |> Map.put(:action, :validate)

    expressions =
      CsvReader.read_csv_and_get_column_names("priv/static/csv/#{plot_params["dataset"]}")

    {:noreply,
     assign_form(socket, changeset)
     |> assign(expressions: expressions)
     |> assign(expression_error: expression_error)}
  end

  def handle_event("save", %{"plot" => plot_params}, socket) do
    plot_params = Map.put(plot_params, "expression", socket.assigns.expression_string)

    if String.match?(socket.assigns.expression_string, ~r/^[-+\/*].*|.*[-+\/*]$/) do
      {:noreply, socket |> assign(expression_error: "expression in invalid")}
    else
      save_plot(socket, socket.assigns.action, plot_params)
    end
  end

  defp save_plot(socket, :edit, plot_params) do
    case Resources.update_plot(socket.assigns.plot, plot_params) do
      {:ok, plot} ->
        notify_parent({:saved, plot})

        {:noreply,
         socket
         |> put_flash(:info, "Plot updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_plot(socket, :new, plot_params) do
    case Resources.create_plot(plot_params) do
      {:ok, plot} ->
        notify_parent({:saved, plot})

        {:noreply,
         socket
         |> put_flash(:info, "Plot created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
