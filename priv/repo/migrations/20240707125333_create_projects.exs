defmodule HillChart.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    # First, delete all existing tickets
    execute "DELETE FROM tickets"

    create table(:projects, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :freeform, :text

      timestamps(type: :utc_datetime)
    end

    drop table(:tickets)

    # Recreate the tickets table with the project_id foreign key
    create table(:tickets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :label, :string
      add :url, :string
      add :colour, :string
      add :completion, :integer

      add :project_id, references(:projects, type: :binary_id, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    # Add an index on project_id for better query performance
    create index(:tickets, [:project_id])
  end
end
