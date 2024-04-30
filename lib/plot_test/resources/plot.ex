defmodule PlotTest.Resources.Plot do
  alias PlotTest.PlotUser
  use Ecto.Schema
  import Ecto.Changeset

  schema "plots" do
    field :name, :string
    field :dataset, :string
    field :expression, :string
    belongs_to :created_by, PlotTest.Accounts.User
    has_many :users, PlotUser, foreign_key: :plot_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(plot, attrs) do
    plot
    |> cast(attrs, [:name, :dataset, :expression, :created_by_id])
    |> validate_required([:name, :dataset, :expression, :created_by_id])
  end
end
