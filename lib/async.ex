defmodule Tweetex.Async do
	@doc """
	This is a test Genserver.  Going to Eventually 
	Wrap the HTTP call with a async function
	"""
		use GenServer
	
		def start do
			GenServer.start(__MODULE__, nil)
		end
	
		def put(pid, key, value) do
			GenServer.cast(pid, {:put, key, value})
		end

		def list(pid) do
			GenServer.call(pid, :list)
		end
	
		def get(pid, key) do
			GenServer.call(pid, {:get, key})
		end
	
		def init(_) do
			{:ok, %{}}
		end
	
		def handle_cast({:put, key, value}, state) do
			# Perform a HTTP mutation
			{:noreply, Map.put(state, key, value)}
		end
	
		def handle_call({:get, key}, _, state) do
			#Perform a HTTP read-only operation
			{:reply, Map.get(state, key), state}
		end
		
		def handle_call(:list, _, state) do
			{:reply, state, state}
		end
	
end