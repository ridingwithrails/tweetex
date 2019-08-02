defmodule Tweetex do
  defp creds do
    Tweetex.Oauth.build_params |> OAuther.credentials      
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

  
end
