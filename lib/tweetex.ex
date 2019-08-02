defmodule Tweetex do
  defp creds do
    build_params |> OAuther.credentials      
  end

  defp sign(method, resource, params) do
    OAuther.sign(method, resource, params, creds)
  end

  defp build_request(method, resource, params) do
    signature = sign(method, resource, params) 
    {header, req_params} = OAuther.header(signature)
    %{header: [header], params: req_params, method: method, resource: resource}   
  end
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

  defp build_params do
    [
      consumer_key: Application.get_env(:tweetex, :consumer_key),
      consumer_secret: Application.get_env(:tweetex, :consumer_secret), 
      token: Application.get_env(:tweetex, :token),
      token_secret: Application.get_env(:tweetex, :token_secret)
    ]
  end
end
