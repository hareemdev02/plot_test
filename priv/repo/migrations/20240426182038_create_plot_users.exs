defmodule PlotTest.Repo.Migrations.CreatePlotUsers do
  use Ecto.Migration

  def change do
    create table(:plot_users) do
      add :plot_id, references(:plots, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:plot_users, [:plot_id])
    create index(:plot_users, [:user_id])
  end
end
