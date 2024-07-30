defmodule HillChart.Tracked.Project.Persistence.Schema do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  alias HillChart.Tracked.Ticket.Persistence.Schema, as: Ticket

  # TODO: Set min and max length on properties

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  typed_schema "projects" do
    field :name, :string
    field :description, :string
    field :freeform, :string

    has_many :tickets, Ticket, foreign_key: :project_id

    timestamps()
  end

  @doc false
  @fields ~w(name description freeform)a
  @required ~w(name description)a
  def changeset(project, attrs) do
    project
    |> cast(attrs, @fields)
    |> validate_required(@required)
  end
end
