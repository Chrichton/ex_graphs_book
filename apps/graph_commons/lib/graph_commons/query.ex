# ---
# Excerpted from "Exploring Graphs with Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/thgraphs for more book information.
# ---
defmodule GraphCommons.Query do
  ## ATTRIBUTES

  @storage_dir GraphCommons.storage_dir()

  ## STRUCT

  @derive {Inspect, except: [:path, :uri]}

  @enforce_keys ~w[data file type]a
  defstruct ~w[data file path type uri]a

  ## TYPES

  @type query_data :: String.t()
  @type query_file :: String.t()
  @type query_path :: String.t()
  @type query_type :: GraphCommons.query_type()
  @type query_uri :: String.t()

  @type t :: %__MODULE__{
          # user
          data: query_data,
          file: query_file,
          type: query_type,
          # system
          path: query_path,
          uri: query_uri
        }

  defguard is_query_type(query_type)
           when query_type in [:dgraph, :native, :property, :rdf, :tinker]

  ## CONSTRUCTOR

  def new(query_data, query_file, query_type)
      when is_query_type(query_type) do
    query_path = "#{@storage_dir}/#{query_type}/queries/#{query_file}"

    %__MODULE__{
      # user
      data: query_data,
      file: query_file,
      type: query_type,
      # system
      path: query_path,
      uri: "file://" <> query_path
    }
  end

  ## IMPLEMENTATIONS

  defimpl Inspect, for: __MODULE__ do
    @slice 16
    @quote <<?">>

    def inspect(%GraphCommons.Query{} = query, _opts) do
      type = query.type
      file = @quote <> query.file <> @quote

      str =
        query.data
        |> String.replace("\n", "\\n")
        |> String.replace(@quote, "\\" <> @quote)
        |> String.slice(0, @slice)

      data =
        case String.length(str) < @slice do
          true -> @quote <> str <> @quote
          false -> @quote <> str <> "..." <> @quote
        end

      "#GraphCommons.Query<type: #{type}, file: #{file}, data: #{data}>"
    end
  end
end
