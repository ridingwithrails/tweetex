defmodule Tweetex do
  #import Tweetex.Client # allows me to call functions without prefix on it.
  import Tweetex.Oauth

  def api_client(), do: Application.get_env(:tweetex, :client)
  
  @doc """
  main is the start of cli to hit twitter.

  Building & Running  the CLI:

  mix escript.build && ./tweetex --source "namegah"

  """
  def main(args) do        
    opts = OptionParser.parse(args, switches: [ method: :string, 
                                                resource: :string,
                                                action: :string,   
                                                params: :string                                               
                                                ])
    case opts do      
      {[method: method, resource: resource, action: action, params: params],_,_} -> 
        #perform(method, resource, action,[{"id", 1156732168808218624}]) #TODO: I need to pass this in.
        params = parse_params(params)               
        perform(method, resource, action, params)
      {[method: method, resource: resource, action: action],_,_} ->          
          params = parse_params("")        
          perform(method, resource, action, params)
       #./tweetex --method "get" --resource "statuses" --action "lookup" --params "[\"id\", 2121]"
      {_,_,_} -> "In correct params sent"
    end
    
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

  @doc """
    Perform calls twitter with: 
    method: http method
    resource: url and path
    params: options to send 

    Returns {:ok, ${HTTPoison.Response}}

    ====iex(8)> Tweetex.perform("get", "statuses", "lookup", [{"id", 1156732168808218624}])
    ==={:ok, ${HTTPoison.Response}}
  """
  def perform(method, object, action, params \\ []) do    
    resource = resource_builder(object, action)
    request = build_request(method, resource, params)
    api_client.fetcher(method, request) |> deserializer
  end

  defp deserializer(payload) do      
    {:ok, twitter_response } =  payload 
    twitter_response.body  |> Poison.decode
  end
end