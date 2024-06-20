defmodule HillChartWeb.Tracked.TicketJSON do
  alias HillChart.Tracked.Ticket.Persistence.Schema, as: Ticket

  @doc """
  Renders a list of tickets.
  """
  def index(%{tickets: tickets}) do
    %{data: for(ticket <- tickets, do: data(ticket))}
  end

  @doc """
  Renders a single ticket.
  """
  def show(%{ticket: ticket}) do
    %{data: data(ticket)}
  end

  defp data(%Ticket{} = ticket) do
    %{
      id: ticket.id,
      label: ticket.label,
      url: ticket.url,
      colour: ticket.colour,
      completion: ticket.completion
    }
  end
end
