defmodule PlotTest.CsvReader do
  NimbleCSV.define(CSV, separator: ",", escape: "\"")

  def read_csv_and_get_column_names(nil), do: nil
  def read_csv_and_get_column_names("priv/static/csv/"), do: nil

  def read_csv_and_get_column_names(file_path) do
    file_path
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Stream.take(2)
    |> Enum.to_list()
    |> find_numerical_columns()
    |> List.flatten()
  end

  def read_csv_and_get_column_values(%{dataset: file_path, expression: column_name}) do
    result =
      "priv/static/csv/#{file_path}"
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)
      |> Stream.map(fn row -> row end)
      |> Enum.to_list()

    index = get_column_index(result, column_name)

    {_, rows} = List.pop_at(result, 0)

    extract_values(rows, index)
  end

  def read_csv_and_get_multiple_column_values(file_path, column_names) do
    result =
      "priv/static/csv/#{file_path}"
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)
      |> Stream.map(fn row -> row end)
      |> Enum.to_list()

    indexes = get_column_indexes(result, column_names)

    {_, rows} = List.pop_at(result, 0)

    extract_values_from_indexes(rows, indexes)
  end

  defp get_column_index(rows, column_name) do
    rows
    |> hd()
    |> Enum.find_index(&(&1 == column_name))
  end

  defp get_column_indexes(rows, column_names) do
    rows
    |> hd()
    |> Enum.with_index(fn el, idx ->
      if el in column_names do
        idx
      end
    end)
    |> Enum.reject(&is_nil(&1))
  end

  defp extract_values_from_indexes(rows, indexes) do
    for index <- indexes do
      Enum.map(rows, fn row ->
        Enum.at(row, index) |> string_to_integer()
      end)
    end
  end

  defp extract_values(rows, index) do
    Enum.map(rows, fn row ->
      Enum.at(row, index) |> string_to_integer()
    end)
  end

  defp string_to_integer(nil), do: nil

  defp string_to_integer(string) when is_binary(string) do
    case Integer.parse(string) do
      {number, _} -> number
      :error -> nil
    end
  end

  defp string_to_integer(integer) when is_integer(integer), do: integer

  defp find_numerical_columns([columns, data]) do
    Enum.with_index(columns, fn el, idx -> {idx, el} end)
    |> Enum.reduce([], fn {idx, el}, acc ->
      value =
        Enum.at(data, idx)
        |> string_to_integer()
        |> is_numerical()

      if value, do: acc ++ [el], else: acc
    end)
  end

  defp is_numerical(value) when is_float(value) or is_integer(value) do
    true
  end

  defp is_numerical(_), do: false
end
