defmodule HillChartWeb.Tracked.ProjectController do
  use HillChartWeb, :controller

  alias HillChart.Tracked.Project.Persistence
  alias HillChart.Tracked.Project.Persistence.Schema, as: Project

  action_fallback HillChartWeb.FallbackController

  def index(conn, _params) do
    projects = Persistence.list_projects()
    render(conn, :index, projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- Persistence.create_project(project_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tracked/projects/#{project}")
      |> render(:show, project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Persistence.get_project!(id)
    render(conn, :show, project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Persistence.get_project!(id)

    with {:ok, %Project{} = project} <- Persistence.update_project(project, project_params) do
      render(conn, :show, project: project)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Persistence.get_project!(id)

    with {:ok, %Project{}} <- Persistence.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end
end
