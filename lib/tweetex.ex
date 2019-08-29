defmodule Tweetex do
  import Tweetex.Client # allows me to call functions without prefix on it.
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
        perform(method, resource, action, params) #TODO: I need to pass this in.     
       
       
       #./tweetex --method "get" --resource "statuses" --action "lookup" --params "[\"id\", 2121]"
      {_,_,_} -> "In correct params sent"
    end

  end

  def parse_params(params) do
    {:ok, data} = Poison.decode(params)
    data    
      |> Enum.chunk_every(2) 
      |> Enum.map(fn pair -> List.to_tuple(pair) end )
  end
end