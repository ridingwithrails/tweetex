defmodule Tweetex.Helpers do 

  @type_map %{
  "video/mp4" => "tweet_video",
  "image/jpg" => "tweet_image",
  "image/png" => "tweet_image",
  "image/gif" => "tweet_gif",
}

  def media_category(file) do    
    @type_map[MIME.from_path(file)]
  end

  def tuple_pairs(params \\"") do
    cond do 
      params == "" -> []
      true -> params 
        |> String.split("=")
        |> transform_to_tuple
    end    
  end
  
  @doc """
  Formats params that comes in to be sent to api

    iex(2)> Tweetex.Helpers.parse_params("[\\"ok\\", \\"Valid\\"]")
    [{"ok", "Valid"}]

    iex(4)> Tweetex.Helpers.parse_params("")
    []

  """

  def parse_params(params \\ " ") do
    case Poison.decode(params) do
      {:ok, data} ->
        transform_to_tuple(data)
      {:error, _, _ } ->
        []
    end
  end

  def transform_to_tuple(data) do
    data
    |> Enum.chunk_every(2)
    |> Enum.map(fn pair -> List.to_tuple(pair) end )
  end

  def encode_params(params) do 
    case Poison.encode(params) do
      {:ok, json} -> json
      {:error, _, _ } -> ""        
    end
  end

@doc """
  form takes a struct and inflates a Map that will be used to perform a mutli-form post.
"""

	def form(form_data) do
		[
			{"media", IO.iodata_to_binary(form_data.data),
				{"form-data", [
					{"name", "\"media\""},
					{"filename", "\"#{form_data.segment}.#{form_data.extension}\""},
					{"media_id", form_data.media_id},
					{"command", "APPEND"},
					{"segment_index", form_data.segment}]},
			[{"Content-Type", form_data.mime}]
			}
		]
	end

end
