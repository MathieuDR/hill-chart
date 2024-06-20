defmodule HillChart.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :label, :string
      add :url, :string
      add :colour, :string
      add :completion, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
