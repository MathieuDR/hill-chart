defmodule HillChart.Web.Tracked.ProjectJSON do
  alias HillChart.Tracked.Project.Persistence.Schema, as: Project

  @doc """
  Renders a list of projects.
  """
  def index(%{projects: projects}) do
    %{data: for(project <- projects, do: data(project))}
  end

  @doc """
  Renders a single project.
  """
  def show(%{project: project}) do
    %{data: data(project)}
  end

  defp data(%Project{} = project) do
    %{
      id: project.id,
      name: project.name,
      description: project.description,
      freeform: project.freeform,
      tickets: maybe_load_tickets(project.tickets)
    }
  end

  defp maybe_load_tickets(%Ecto.Association.NotLoaded{}), do: :not_loaded

  defp maybe_load_tickets(tickets) when is_list(tickets),
    do: Enum.map(tickets, &HillChart.Web.Tracked.TicketJSON.render_ticket/1)
end
