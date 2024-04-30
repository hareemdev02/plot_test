defmodule PlotTest.PlotUser do
  alias PlotTest.Accounts.User
  alias PlotTest.Resources.Plot
  use Ecto.Schema
  import Ecto.Changeset

  schema "plot_users" do
    belongs_to :plot, Plot
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(plot_user, attrs) do
    plot_user
    |> cast(attrs, [:plot_id, :user_id])
    |> validate_required([:plot_id, :user_id])
  end
end
