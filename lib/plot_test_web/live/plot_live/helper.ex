defmodule PlotTestWeb.PlotLive.Helper do
  def csv_options do
    [
      {"2010 alchohol consumption by country", "2010_alcohol_consumption_by_country.csv"},
      {"2011 February AA flight paths", "2011_february_aa_flight_paths.csv"},
      {"2011 February US airport traffic	", "2011_february_us_airport_traffic.csv"},
      {"2011 US agriculture exports	", "2011_us_ag_exports.csv"},
      {"2014 Apple stock", "2014_apple_stock.csv"},
      {"2014 ebola", "2014_ebola.csv"},
      {"2014 US cities population", "2014_us_cities.csv"},
      {"2014 US states population", "2014_usa_states.csv"},
      {"2014 world GDP", "2014_world_gdp_with_codes.csv"},
      {"2015 precipitation", "2015_06_30_precipitation.csv"},
      {"2015 Shooting Incidents", "US-shooting-incidents.csv"},
      {"Climate change subplot", "subplots.csv"},
      {"NYC Uber rides", "uber-rides-data1.csv"},
      {"Prostate cancer", "clustergram_GDS5373.soft"},
      {"School earnings", "school_earnings.csv"},
      {"Volcano", "volcano.csv"},
      {"Wind speed", "wind_speed_laurel_nebraska.csv"},
      {"Walmart store openings", "1962_2006_walmart_store_openings.csv"}
    ]
  end

  def dataset_value("2010_alcohol_consumption_by_country.csv"),
    do: "2010 alchohol consumption by country"

  def dataset_value("2011_february_aa_flight_paths.csv"), do: "2011 February AA flight paths"

  def dataset_value("2011_february_us_airport_traffic.csv"),
    do: "2011 February US airport traffic"

  def dataset_value("2011_us_ag_exports.csv"), do: "2011 US agriculture exports"
  def dataset_value("2014_apple_stock.csv"), do: "2014 Apple stock"
  def dataset_value("2014_ebola.csv"), do: "2014 ebola"
  def dataset_value("2014_us_cities.csv"), do: "2014 US cities population"
  def dataset_value("2014_usa_states.csv"), do: "2014 US states population"
  def dataset_value("2014_world_gdp_with_codes.csv"), do: "2014 world GDP"
  def dataset_value("2015_06_30_precipitation.csv"), do: "2015 precipitation"
  def dataset_value("US-shooting-incidents.csv"), do: "2015 Shooting Incidents"
  def dataset_value("subplots.csv"), do: "Climate change subplot"
  def dataset_value("uber-rides-data1.csv"), do: "NYC Uber rides"
  def dataset_value("clustergram_GDS5373.soft"), do: "Prostate cancer"
  def dataset_value("school_earnings.csv"), do: "School earnings"
  def dataset_value("volcano.csv"), do: "Volcano"
  def dataset_value("wind_speed_laurel_nebraska.csv"), do: "Wind speed"
  def dataset_value("1962_2006_walmart_store_openings.csv"), do: "Walmart store openings"
end
