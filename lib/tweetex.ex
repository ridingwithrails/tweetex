defmodule Tweetex do
  import Tweetex.Oauth
  import Tweetex.Helpers
  import Tweetex.Payload

  # THis grabs the behavior we want from the config file.
  # easier to test.
  def api_client(), do: Application.get_env(:tweetex, :client)

  @doc """
  main is the start of cli to hit twitter.

  Building & Running  the CLI:

  mix escript.build && ./tweetex --source "namegah"

  """
  def main(args) do
    opts = OptionParser.parse(args, switches: [ method: :string,
                                                resource: :string,
                                                file: :string, 
                                                action: :string,                                                
                                                params: :string
                                                ])
    case opts do
      {[method: method, resource: resource, action: action, params: params],_,_} ->        
        performer(method, resource, action, params)
      {[method: method, resource: resource, action: action, file: file,],_,_} ->
        uploader(method, resource, action, file)
      {[method: method, resource: resource, action: action],_,_} ->
        performer(method, resource, action)        
       #./tweetex --method "get" --resource "statuses" --action "lookup" --params "[\"id\", 2121]"       
       {_,_,_} -> "In correct params sent"
    end
  end

  def performer(method, resource, action, params \\ "") do    
    params = tuple_pairs(params)    
    perform(method, resource, action, params)
  end
  

  def uploader(method, resource, action, file,  params \\ "") do 
    
    {:ok, "upload done!"}
  end


  

  @doc """
    Perform calls twitter with:
    method: http method
    resource: url and path
    params: options to send

    Returns {:ok, ${HTTPoison.Response}}
  """
  def perform(method, object, action, params \\ []) do
    resource = resource_builder(object, action)
    request = build_request(method, resource, params)
    api_client.fetcher(method, request) |> body 
  end
end
