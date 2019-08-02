defmodule Tweetex do
  import Tweetex.Oauth # allows me to call functions without prefix on it.
 @doc """
    Perform calls twitter with: 
    method: http method
    resource: url and path
    params: options to send 

    Returns {:ok, ${HTTPoison.Response}}

    iex(8)> Tweetex.perform("get", "https://api.twitter.com/1.1/statuses/lookup.json", [{"id", 485086311205048320}])

  """

  def perform(method, resource, params) do
    request = build_request(method, resource, params)
    HTTPoison.get(request.resource, request.header, params: request.params)
  end
end
