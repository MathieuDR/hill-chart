defmodule HillChart.Tracked.Project.PersistenceTest do
  # use HillChart.DataCase, async: true
  use ExUnit.Case, async: true

  alias Factories.TrackedFactory

  describe "something" do
    test "should do something" do
      TrackedFactory.project_generator()
      |> Enum.take(10)
      |> IO.inspect()
    end
  end
end

