defmodule Tweetex.Helpers do 
	@doc """
  Formats params that comes in to be sent to api

    iex(2)> Tweetex.parse_params("[\\"ok\\", \\"Valid\\"]")
    [{"ok", "Valid"}]

    iex(4)> Tweetex.parse_params("")
    []

  """
  def media_category(file) do
    file_type = MIME.from_path(file)
    cats = %{
      "video/mp4" => "tweet_video",
      "image/jpg" => "tweet_image",
      "image/png" => "tweet_image",
      "image/gif" => "tweet_gif",
    }
    cats[file_type]
  end


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
