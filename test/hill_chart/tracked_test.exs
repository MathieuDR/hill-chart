defmodule HillChart.TrackedTest do
  use HillChart.DataCase

  alias HillChart.Tracked

  describe "tickets" do
    alias HillChart.Tracked.Ticket

    import HillChart.TrackedFixtures

    @invalid_attrs %{label: nil, completion: nil, url: nil, last_update: nil, colour: nil}

    test "list_tickets/0 returns all tickets" do
      ticket = ticket_fixture()
      assert Tracked.list_tickets() == [ticket]
    end

    test "get_ticket!/1 returns the ticket with given id" do
      ticket = ticket_fixture()
      assert Tracked.get_ticket!(ticket.id) == ticket
    end

    test "create_ticket/1 with valid data creates a ticket" do
      valid_attrs = %{
        label: "some label",
        completion: 42,
        url: "some url",
        last_update: ~U[2024-06-19 18:32:00Z],
        colour: "some colour"
      }

      assert {:ok, %Ticket{} = ticket} = Tracked.create_ticket(valid_attrs)
      assert ticket.label == "some label"
      assert ticket.completion == 42
      assert ticket.url == "some url"
      assert ticket.last_update == ~U[2024-06-19 18:32:00Z]
      assert ticket.colour == "some colour"
    end

    test "create_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracked.create_ticket(@invalid_attrs)
    end

    test "update_ticket/2 with valid data updates the ticket" do
      ticket = ticket_fixture()

      update_attrs = %{
        label: "some updated label",
        completion: 43,
        url: "some updated url",
        last_update: ~U[2024-06-20 18:32:00Z],
        colour: "some updated colour"
      }

      assert {:ok, %Ticket{} = ticket} = Tracked.update_ticket(ticket, update_attrs)
      assert ticket.label == "some updated label"
      assert ticket.completion == 43
      assert ticket.url == "some updated url"
      assert ticket.last_update == ~U[2024-06-20 18:32:00Z]
      assert ticket.colour == "some updated colour"
    end

    test "update_ticket/2 with invalid data returns error changeset" do
      ticket = ticket_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracked.update_ticket(ticket, @invalid_attrs)
      assert ticket == Tracked.get_ticket!(ticket.id)
    end

    test "delete_ticket/1 deletes the ticket" do
      ticket = ticket_fixture()
      assert {:ok, %Ticket{}} = Tracked.delete_ticket(ticket)
      assert_raise Ecto.NoResultsError, fn -> Tracked.get_ticket!(ticket.id) end
    end

    test "change_ticket/1 returns a ticket changeset" do
      ticket = ticket_fixture()
      assert %Ecto.Changeset{} = Tracked.change_ticket(ticket)
    end
  end

  describe "projects" do
    alias HillChart.Tracked.Project

    import HillChart.TrackedFixtures

    @invalid_attrs %{name: nil, description: nil, freeform: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Tracked.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Tracked.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{name: "some name", description: "some description", freeform: "some freeform"}

      assert {:ok, %Project{} = project} = Tracked.create_project(valid_attrs)
      assert project.name == "some name"
      assert project.description == "some description"
      assert project.freeform == "some freeform"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracked.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", freeform: "some updated freeform"}

      assert {:ok, %Project{} = project} = Tracked.update_project(project, update_attrs)
      assert project.name == "some updated name"
      assert project.description == "some updated description"
      assert project.freeform == "some updated freeform"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracked.update_project(project, @invalid_attrs)
      assert project == Tracked.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Tracked.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Tracked.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Tracked.change_project(project)
    end
  end
end
