# ---
# Excerpted from "Exploring Graphs with Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/thgraphs for more book information.
# ---
defmodule GraphCommons.Graph do
  ## ATTRIBUTES

  @storage_dir GraphCommons.storage_dir()

  ## STRUCT

  @derive {Inspect, except: [:path, :uri]}

  @enforce_keys ~w[data file type]a
  defstruct ~w[data file path type uri]a

  ## TYPES

  @type graph_data :: String.t()
  @type graph_file :: String.t()
  @type graph_path :: String.t()
  @type graph_type :: GraphCommons.graph_type()
  @type graph_uri :: String.t()

  @type t :: %__MODULE__{
          # user
          data: graph_data,
          file: graph_file,
          type: graph_type,
          # system
          path: graph_path,
          uri: graph_uri
        }

  defguard is_graph_type(graph_type)
           when graph_type in [:dgraph, :native, :property, :rdf, :tinker]

  ## CONSTRUCTOR

  def new(graph_data, graph_file, graph_type)
      when is_graph_type(graph_type) do
    graph_path = "#{@storage_dir}/#{graph_type}/graphs/#{graph_file}"

    %__MODULE__{
      # user
      data: graph_data,
      file: graph_file,
      type: graph_type,
      # system
      path: graph_path,
      uri: "file://" <> graph_path
    }
  end
end
