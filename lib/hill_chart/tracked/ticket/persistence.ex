defmodule HillChart.Tracked.Ticket.Persistence do
  @moduledoc """
  The Tracked context.
  """

  import Ecto.Query, warn: false
  alias HillChart.Repo

  alias HillChart.Tracked.Ticket.Persistence.Schema, as: Ticket

  @doc """
  Returns the list of tickets.

  ## Examples

      iex> list_tickets()
      [%Ticket{}, ...]

  """
  def list_tickets do
    Repo.all(Ticket)
  end

  @doc """
  Gets a single ticket.

  Raises `Ecto.NoResultsError` if the Ticket does not exist.

  ## Examples

      iex> get_ticket!(123)
      %Ticket{}

      iex> get_ticket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ticket!(id), do: Repo.get!(Ticket, id)

  @doc """
  Creates a ticket.

  ## Examples

      iex> create_ticket(%{field: value})
      {:ok, %Ticket{}}

      iex> create_ticket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ticket(attrs \\ %{}) do
    IO.inspect(attrs, label: "attrs")

    %Ticket{}
    |> Ticket.changeset(attrs)
    |> IO.inspect(label: "ticket")
    |> Repo.insert()
  end

  @doc """
  Updates a ticket.

  ## Examples

      iex> update_ticket(ticket, %{field: new_value})
      {:ok, %Ticket{}}

      iex> update_ticket(ticket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ticket(%Ticket{} = ticket, attrs) do
    ticket
    |> Ticket.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ticket.

  ## Examples

      iex> delete_ticket(ticket)
      {:ok, %Ticket{}}

      iex> delete_ticket(ticket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ticket(%Ticket{} = ticket) do
    Repo.delete(ticket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket changes.

  ## Examples

      iex> change_ticket(ticket)
      %Ecto.Changeset{data: %Ticket{}}

  """
  def change_ticket(%Ticket{} = ticket, attrs \\ %{}) do
    Ticket.changeset(ticket, attrs)
  end

  @doc """
  Deletes all ticket

  ## Examples
    iex> delete_all()
    {1, nil}
  """
  def delete_all() do
    Repo.delete_all(Ticket)
  end

  @doc """
  Deletes all tickets with the given id

  ## Examples
    iex> delete_all([id1, id2])
    {2, nil}
  """
  def delete_all(ids) do
    Ticket
    |> where([p], p.id in ^ids)
    |> Repo.delete_all()
  end
end
