defmodule PlotTest.Repo do
  use Ecto.Repo,
    otp_app: :plot_test,
    adapter: Ecto.Adapters.Postgres
end
