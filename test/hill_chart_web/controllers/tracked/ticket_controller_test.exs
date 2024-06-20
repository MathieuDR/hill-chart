defmodule HillChartWeb.Tracked.TicketControllerTest do
  use HillChartWeb.ConnCase

  import HillChart.TrackedFixtures

  alias HillChart.Tracked.Ticket

  @create_attrs %{
    label: "some label",
    completion: 42,
    url: "some url",
    last_update: ~U[2024-06-19 18:32:00Z],
    colour: "some colour"
  }
  @update_attrs %{
    label: "some updated label",
    completion: 43,
    url: "some updated url",
    last_update: ~U[2024-06-20 18:32:00Z],
    colour: "some updated colour"
  }
  @invalid_attrs %{label: nil, completion: nil, url: nil, last_update: nil, colour: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tickets", %{conn: conn} do
      conn = get(conn, ~p"/api/tracked/tickets")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create ticket" do
    test "renders ticket when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/tracked/tickets", ticket: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/tracked/tickets/#{id}")

      assert %{
               "id" => ^id,
               "colour" => "some colour",
               "completion" => 42,
               "label" => "some label",
               "last_update" => "2024-06-19T18:32:00Z",
               "url" => "some url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/tracked/tickets", ticket: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update ticket" do
    setup [:create_ticket]

    test "renders ticket when data is valid", %{conn: conn, ticket: %Ticket{id: id} = ticket} do
      conn = put(conn, ~p"/api/tracked/tickets/#{ticket}", ticket: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/tracked/tickets/#{id}")

      assert %{
               "id" => ^id,
               "colour" => "some updated colour",
               "completion" => 43,
               "label" => "some updated label",
               "last_update" => "2024-06-20T18:32:00Z",
               "url" => "some updated url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, ticket: ticket} do
      conn = put(conn, ~p"/api/tracked/tickets/#{ticket}", ticket: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete ticket" do
    setup [:create_ticket]

    test "deletes chosen ticket", %{conn: conn, ticket: ticket} do
      conn = delete(conn, ~p"/api/tracked/tickets/#{ticket}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/tracked/tickets/#{ticket}")
      end
    end
  end

  defp create_ticket(_) do
    ticket = ticket_fixture()
    %{ticket: ticket}
  end
end
