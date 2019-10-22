defmodule Tweetex.ChunkedUploader do
	import Tweetex.UploadActions

	# Going to work on this some more this is not final .
	def work(file) do
		{:ok, media_data }= init(file)
		media_id = Map.get media_data, "media_id"
		split(file, media_id)
		finalize(media_id)
		# Need to implement a status mechanism here.
	end
end