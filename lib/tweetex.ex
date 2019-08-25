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
                                                # params: :string                                               
                                                ])
    IO.inspect opts 
    str = case opts do
      {[method: method, resource: resource, action: action],_,_} -> 
        perform(method, resource, action,[{"id", 1156732168808218624}])
      {_,_,_} -> "No match"
    end
    IO.inspect args 
    IO.puts str
  end
end

# CLI works like: 
# mix escript.build
#