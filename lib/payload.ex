defmodule Tweetex.Payload do
	def deserializer(payload) do
    {:ok, twitter_response } =  payload
    twitter_response.body  |> Poison.decode
  end
end
 