defmodule HillChart.Tracked.Ticket.Persistence.Schema do
  use TypedEctoSchema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  typed_schema "tickets" do
    field(:label, :string)
    field(:completion, :integer, default: 0)
    field(:url, :string)
    field(:colour, :string)

    timestamps()
  end

  @doc false
  @fields ~w(label url colour completion)a
  @required ~w(label url)a
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> Map.put(:colour, generate_colour(attrs))
  end

  defp generate_colour(_attrs), do: "#1e1e2e"
end
