defmodule PlotTestWeb.PlotLive.Show do
  alias PlotTest.CsvReader
  use PlotTestWeb, :live_view

  alias PlotTest.Resources

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    plot = Resources.get_plot!(id)

    operators = ~r{[+\-*/]}
    column_names = String.split(plot.expression, operators, trim: true)

    operations =
      String.split(plot.expression, ~r{\w+}, trim: true)
      |> Enum.reject(&(String.trim(&1) == ""))

    values =
      if Enum.count(column_names) == 1 do
        CsvReader.read_csv_and_get_column_values(plot) |> Jason.encode!()
      else
        v = CsvReader.read_csv_and_get_multiple_column_values(plot.dataset, column_names)
        calculate(operations, v) |> Enum.map(fn x -> evaluate_tokens(x) end) |> Jason.encode!()
      end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:plot, plot)
     |> assign(:values, values)}
  end

  defp page_title(:show), do: "Show Plot"
  defp page_title(:edit), do: "Edit Plot"

  defp calculate(operations, column_values) do
    a =
      Enum.zip(column_values) |> Enum.map(&Tuple.to_list(&1))

    # opi = Enum.with_index(operations, fn element, index -> {index, element} end)

    Enum.map(a, fn x ->
      merge(x, operations) ++ [List.last(x)]
    end)
  end

  def merge([], _), do: []
  def merge(_, []), do: []

  def merge([a | as], [b | bs]) do
    [a, b] ++ merge(as, bs)
  end

  # Handle case where one list is shorter than the other
  def merge([], remaining), do: remaining
  def merge(remaining, []), do: remaining

  def test_calc(expression) do
    tokens =
      expression
      |> String.replace("+", " + ")
      |> String.replace("-", " - ")
      |> String.replace("/", " / ")
      |> String.replace("*", " * ")
      |> String.split(" ")

    evaluate_tokens(tokens)
  end

  defp evaluate_tokens([number | rest]) do
    evaluate_tokens(rest, string_to_integer(number))
  end

  defp evaluate_tokens(["*", number | rest], acc) do
    new_acc = acc * string_to_integer(number)
    evaluate_tokens(rest, new_acc)
  end

  defp evaluate_tokens(["/", number | rest], acc) do
    new_acc = acc / string_to_integer(number)
    evaluate_tokens(rest, new_acc)
  end

  defp evaluate_tokens([operator, number | rest], acc) when operator in ["+", "-"] do
    new_acc =
      case operator do
        "+" -> acc + string_to_integer(number)
        "-" -> acc - string_to_integer(number)
      end

    evaluate_tokens(rest, new_acc)
  end

  defp evaluate_tokens([], acc) do
    acc
  end

  defp string_to_integer(nil), do: nil

  defp string_to_integer(string) when is_binary(string) do
    case Integer.parse(string) do
      {number, _} -> number
      :error -> nil
    end
  end

  defp string_to_integer(integer) when is_integer(integer), do: integer
end
