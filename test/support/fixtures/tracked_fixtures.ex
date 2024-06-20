defmodule HillChart.TrackedFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HillChart.Tracked` context.
  """

  @doc """
  Generate a ticket.
  """
  def ticket_fixture(attrs \\ %{}) do
    {:ok, ticket} =
      attrs
      |> Enum.into(%{
        colour: "some colour",
        completion: 42,
        label: "some label",
        last_update: ~U[2024-06-19 18:32:00Z],
        url: "some url"
      })
      |> HillChart.Tracked.create_ticket()

    ticket
  end
end
