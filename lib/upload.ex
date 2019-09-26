defmodule Tweetex.Upload do
	import Tweetex.Oauth 
	import Tweetex.Helpers
	import Tweetex.Client 

	@stage  "./stage"
	@output "./lib/output"
	@host "https://upload.twitter.com"
	@version "1.1"
	@method "post"

# Returns 
# body: "{\"media_id\":1177054564421255168,\"media_id_string\":\"1177054564421255168\",\"expires_after_secs\":86399}"

	def init(file) do
		{:ok, %{size: size} } = File.stat("./stage/#{file}")
		{:ok, init_params} =  [ 
			"media_type", "video/mp4", 
			"resource", "media",
			"total_bytes", size,
			"action", "upload", 
			"command", "INIT"
			] |> Poison.encode 
		params = parse_params(init_params)
		resource = upload_resource_builder("media", "upload")
		request = build_request("post", resource, params)
		uploader("post", request)
	end

	def finalize(media_id) do
		{:ok, init_params} =  [ 			
			"media_id", Integer.to_string(media_id),
			"command", "FINALIZE"
			] |> Poison.encode 
		params = parse_params(init_params)
		resource = upload_resource_builder("media", "upload")
		request = build_request("post", resource, params)
		uploader("post", request)		
	end

	def status(media_id) do
		{:ok, init_params} =  [ 			
			"command", "STATUS",
			"media_id", Integer.to_string(media_id)			
			] |> Poison.encode 
		params = parse_params(init_params)
		resource = upload_resource_builder("media", "upload")
		request = build_request("get", resource, params)
		uploader("get", request)

	end

	def upload_resource_builder(object, action) do
    @host <> "/" <> @version <> "/" <> object <> "/" <> "#{action}.json"
	end
	
	def split_append(media_id, file) do
		File.stream!("#{@stage}/#{file}", [],  4999990) 
		|> Stream.chunk_every(4999990)  
		|> Stream.with_index 
		|> Stream.each( fn({data, chunk_id}) -> append(media_id, data, chunk_id) end ) 
		|> Stream.run()
	end


	def append(media_id, file_data, segment) do		
		{:ok, data} = File.read("./lib/output/#{file_data}")
		{:ok, append_params} =  [ 
			"media_id", media_id, 			
			"segment_index", segment,			
			"command", "APPEND"
			] |> Poison.encode 
		params = parse_params(append_params)
		IO.inspect params
		resource = upload_resource_builder("media", "upload")
		request = build_request_media("post", resource, params)	
		form = {:multipart, [
				{"media", data }, 
				{"media_id", Integer.to_string(media_id)}, 				
			]}
		HTTPoison.post(request.resource, form, request.header, params: request.params) |> IO.inspect		
	end

	def split(file)  do
		File.stream!("#{@stage}/#{file}", [],  4999990) 
			# |> Stream.chunk_every(5120)  
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