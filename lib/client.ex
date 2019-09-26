defmodule Tweetex.Client do  
  @behaviour Tweetex.ClientBehavior
  @doc """
  Fetcher takes the options passed in from perform and makes the call to the API

  Tweetex.Client.fetcher("get", "statuses", "lookup", [{"id", 1156732168808218624}])

  """
  def fetcher(method, request) do
    case method do
     "get" -> 
        HTTPoison.get(request.resource, request.header, params: request.params) 
     "post" -> 
        HTTPoison.post(request.resource, [], request.header, params: request.params) 
     end
   end   

   def uploader(method, request) do
     case method do
       "get" -> 
         HTTPoison.get(request.resource, request.header, params: request.params) 
       "post" -> 
         HTTPoison.post(request.resource, [], request.header, params: request.params) 
      end
   end
end

