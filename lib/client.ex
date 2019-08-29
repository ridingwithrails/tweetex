defmodule Tweetex.Client do
	import Tweetex.Oauth
	@doc """
  Fetcher takes the options passed in from perform and makes the call to the API

  Tweetex.fetcher("get", "statuses", "lookup", [{"id", 1156732168808218624}])

  """
  defp fetcher(method, object, action, params \\ []) do
    resource = resource_builder(object, action)
    
    request = build_request(method, resource, params)
    # case method do
    HTTPoison.get(request.resource, request.header, params: request.params) 
      
    #   "post" -> 
    #     IO.inspect request.params
    #     HTTPoison.post(request.resource, request.header, Poison.encode(request.params)) 
    # end
   end

   @doc """
    Perform calls twitter with: 
    method: http method
    resource: url and path
    params: options to send 

    Returns {:ok, ${HTTPoison.Response}}

    iex(8)> Tweetex.Client.perform("get", "statuses", "lookup", [{"id", 1156732168808218624}])

  """

  def perform(method, object, action, params \\ []) do
    fetcher(method, object, action, params) |> deserializer
  end

  def resource_builder(object, action) do
    Application.get_env(:tweetex, :base_url) <> "/" <> 
    Application.get_env(:tweetex, :version) <> "/" <>
      object <> "/" <> "#{action}.json"
  end

  defp deserializer(payload) do  
    {:ok, twitter_response } =  payload 
    twitter_response.body  |> Poison.decode |> IO.inspect 
  end
end
