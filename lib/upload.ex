defmodule Tweetex.Upload do
	import Tweetex.Oauth 
	import Tweetex.Helpers
	@stage  "./stage"
	@output "./lib/output"
	@host "https://upload.twitter.com"
	@version "1.1"
	@method "post"


	def init(file) do
		{:ok, %{size: size} } = File.stat("./stage/#{file}")
		{:ok, init_params} =  [ "media_type", "video/mp4", "resource", "media",
		"action", "upload", "command", "init"] |> Poison.encode 
		params = parse_params(init_params)
		resource = upload_resource_builder("media", "upload")
		build_request("post", resource, params)
	end

	def upload_resource_builder(object, action) do
    @host <> "/" <> @version <> "/" <> object <> "/" <> "#{action}.json"
  end



	def post(mediafile)  do
		File.stream!("#{@stage}/#{mediafile}", [], 5120) 
			|> Stream.chunk_every(5120)  
			|> Stream.with_index 
			|> Stream.each( 
					fn({data, chunk_id}) -> {:ok, file} = File.open("#{@output}/#{chunk_id}.tmp",[:write] )
					IO.binwrite(file, data)
				end) 
			|> Stream.run()
	end

	def join(finalfile) do
		{:ok, finished_file} = File.open("./#{finalfile}.mp4", [:write])
		{:ok, files} = File.ls("#{@output}") 
		file_count = Enum.count(files) 
		filename_range = (0..(file_count - 1) )
		Enum.each(filename_range, fn file_name ->
			{:ok, file} = File.read("#{@output}/#{file_name}.tmp")
			IO.binwrite(finished_file, file)			
		end)
		File.close(finished_file)
	end
end