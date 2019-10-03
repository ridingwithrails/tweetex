defmodule Tweetex.Payload do
	def body(payload) do
    {:ok, twitter_response } =  payload
    twitter_response.body  |> Poison.decode
  end

  def status_code(payload) do
    {:ok, twitter_response } =  payload
    twitter_response.status_code
  end
end
 