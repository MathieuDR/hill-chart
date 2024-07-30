defmodule HillChart.Web.Tracked.TicketController do
  use HillChart.Web, :controller

  alias HillChart.Tracked.Ticket.Persistence
  alias HillChart.Tracked.Ticket.Persistence.Schema, as: Ticket

  action_fallback(HillChart.Web.FallbackController)

  def index(conn, _params) do
    tickets = Persistence.list_tickets()
    render(conn, :index, tickets: tickets)
  end

  def create(conn, %{"ticket" => ticket_params}) do
    with {:ok, %Ticket{} = ticket} <- Persistence.create_ticket(ticket_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/tracked/tickets/#{ticket}")
      |> render(:show, ticket: ticket)
    end
  end

  def show(conn, %{"id" => id}) do
    ticket = Persistence.get_ticket!(id)
    render(conn, :show, ticket: ticket)
  end

  def update(conn, %{"id" => id, "ticket" => ticket_params}) do
    ticket = Persistence.get_ticket!(id)

    with {:ok, %Ticket{} = ticket} <- Persistence.update_ticket(ticket, ticket_params) do
      render(conn, :show, ticket: ticket)
    end
  end

  def delete(conn, %{"id" => id}) do
    ticket = Persistence.get_ticket!(id)

    with {:ok, %Ticket{}} <- Persistence.delete_ticket(ticket) do
      send_resp(conn, :no_content, "")
    end
  end
end
