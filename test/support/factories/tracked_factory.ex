defmodule Factories.TrackedFactory do
  @moduledoc false
  use ExUnitProperties

  alias Factories.UriFactory
  alias HillChart.Tracked.Project.Persistence.Schema, as: Project
  alias HillChart.Tracked.Ticket.Persistence.Schema, as: Ticket

  def project_generator do
    gen all name <- string(:utf8, min_length: 1, max_length: 50),
            description <- string(:utf8, min_length: 0, max_length: 250),
            freeform <- string(:utf8, min_length: 0, max_length: 1000),
            tickets <- list_of(ticket_generator(), min_length: 0, max_length: 10) do
      %Project{
        name: name,
        description: description,
        freeform: freeform,
        tickets: tickets
      }
    end
  end

  def ticket_generator do
    gen all label <- string(:utf8, min_length: 1, max_length: 50),
            completion <- integer(0..100),
            uri <- UriFactory.uri_generator(),
            colour <- colour_generator() do
      %Ticket{
        label: label,
        completion: completion,
        url: URI.to_string(uri),
        colour: "#" <> Chameleon.convert(colour, Chameleon.Hex).hex
      }
    end
  end

  def colour_generator do
    gen all red <- integer(0..255),
            green <- integer(0..255),
            blue <- integer(0..255) do
      Chameleon.RGB.new(red, green, blue)
    end
  end
end
