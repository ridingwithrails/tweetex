defmodule Tweetex.Helpers do 
	@doc """
  Formats params that comes in to be sent to api

    iex(2)> Tweetex.parse_params("[\\"ok\\", \\"Valid\\"]")
    [{"ok", "Valid"}]

    iex(4)> Tweetex.parse_params("")
    []

  """

  def parse_params(params \\ " ") do
    case Poison.decode(params) do
      {:ok, data} ->
        data
        |> Enum.chunk_every(2)
        |> Enum.map(fn pair -> List.to_tuple(pair) end )
      {:error, _, _ } ->
        []
    end
  end
end
