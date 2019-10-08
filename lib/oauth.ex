defmodule Tweetex.Oauth do
	def creds() do
    build_params |> OAuther.credentials      
  end

  def sign(method, resource, params) do
    OAuther.sign(method, resource, params, creds)
  end

  def build_request(method, resource, params) do
    signature = sign(method, resource, params) 
    {header, req_params} = OAuther.header(signature)
    %{header: [header], params: req_params, method: method, resource: resource}   
  end
  
  def resource_builder(object, action, host \\ nil) do
    if  host == nil  do     
      Application.get_env(:tweetex, :base_url) <> resource_fragment(object, action)
    else 
      host <> resource_fragment(object, action)
    end    
  end

  defp resource_fragment(object, action) do
    Application.get_env(:tweetex, :version) <> "/" 
        <> object <> "/" <> "#{action}.json"
  end
  
	defp build_params() do
    [
      consumer_key: Application.get_env(:tweetex, :consumer_key),
      consumer_secret: Application.get_env(:tweetex, :consumer_secret), 
      token: Application.get_env(:tweetex, :token),
      token_secret: Application.get_env(:tweetex, :token_secret)
    ]
  end
end