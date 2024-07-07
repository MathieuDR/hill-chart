defmodule HillChart.Tracked.Ticket.Persistence.Schema do
  use TypedEctoSchema
  import Ecto.Changeset

  alias HillChart.Tracked.Project.Persistence.Schema, as: Project

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  typed_schema "tickets" do
    field(:label, :string)
    field(:completion, :integer, default: 0)
    field(:url, :string)
    field(:colour, :string)

    belongs_to :project, Project, type: :binary_id

    timestamps()
  end

  @doc false
  @fields ~w(label url colour completion project_id)a
  @required ~w(label url project_id)a
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> foreign_key_constraint(:project_id)
    |> put_colour(attrs)
  end

  defp put_colour(changeset, attrs) do
    if Map.has_key?(attrs, :colour) do
      changeset
    else
      put_change(changeset, :colour, generate_colour(attrs))
    end
  end

  defp generate_colour(_attrs), do: "#1e1e2e"
end
