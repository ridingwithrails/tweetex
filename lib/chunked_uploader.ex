defmodule Tweetex.ChunkedUploader do
	import Tweetex.UploadActions

	# Going to work on this some more this is not final .
	def work(file) do
		{:ok, media_data }= init(file)
		media_id = Map.get media_data, "media_id"
		split(file, media_id)
		finalize(media_id)
		find_status(media_id)		
	end

	def find_status(media_id) do
		Process.sleep(1000)
		media_data = status(media_id)
		case processing?(media_data) do
			true  -> find_status(media_id)
			false -> media_data
		end
	end
	
	def processing?(media_data) do 
		{:ok, data} = media_data		
		state(data) != "succeeded"
	end

	@doc """
	Extracts state from payload given payload.
	"""

	def state(data) do
		data
			|> Map.get("processing_info") 
			|> Map.get("state")
	end
end