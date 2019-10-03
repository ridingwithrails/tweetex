defmodule Tweetex.Upload do
	import Tweetex.Oauth 
	import Tweetex.Helpers
	import Tweetex.Client 
	import Tweetex.Payload
	import Tweetex.FileManager

	@stage  "./stage"
	@host "https://upload.twitter.com"
	@version "1.1"
	@method "post"

# Returns 
# body: "{\"media_id\":1177054564421255168,\"media_id_string\":\"1177054564421255168\",\"expires_after_secs\":86399}"
# 1178102583539298304
	def init(file) do
		{:ok, %{size: size} } = File.stat("./stage/#{file}")
		{:ok, init_params} =  [ 
			"media_type", "video/mp4", 
			"media_category", "tweet_video",
			"resource", "media",
			"total_bytes", size,
			"action", "upload", 
			"command", "INIT"
			] |> Poison.encode 
		params = parse_params(init_params)
		resource = upload_resource_builder("media", "upload")
		request = build_request(@method, resource, params)
		uploader(@method, request) |> body 
	end

	def finalize(media_id) do
		{:ok, init_params} =  [ 			
			"media_id", Integer.to_string(media_id),
			"command", "FINALIZE"
			] |> Poison.encode 
		params = parse_params(init_params)
		resource = upload_resource_builder("media", "upload")
		request = build_request(@method, resource, params)
		uploader(@method, request)	|> body 	
	end

	def status(media_id) do
		{:ok, init_params} =  [ 			
			"command", "STATUS",
			"media_id", media_id		
			] |> Poison.encode 
		params = parse_params(init_params)
		resource = upload_resource_builder("media", "upload")
		request = build_request("get", resource, params)
		uploader("get", request) |> body
	end

	def split_append(media_id, file) do		
		IO.puts "Spliting #{file} into chunks"
		output_dir = split(file) 		
		get_range(output_dir)
			|> Enum.each(fn segment -> append(media_id, segment, output_dir) end)
		File.rm_rf output_dir	
	end

	def split(file, media_id) do 		
		File.stream!("#{@stage}/#{file}", [],  4999990) 			 
			|> Stream.with_index 
			|> Stream.each(		
					fn({data, segment}) -> append(media_id, segment, data)
					end) 
			|> Stream.run()
	end

	def append(media_id, segment, data) do		 		
		{:ok, append_params} =  [ 
			"media_id", media_id, 				
			"command", "APPEND",
			"segment_index", segment,				
			] |> Poison.encode 
		 params = parse_params(append_params)		
		resource = upload_resource_builder("media", "upload")
		request = build_request(@method, resource, params)		
		form = [
			{"media", IO.iodata_to_binary(data), 
				{"form-data", [
					{"name", "\"media\""},
					{"filename", "\"#{segment}.mp4\""},
					{"media_id", media_id}, 				
					{"command", "APPEND"},
					{"segment_index", segment}]},
			[{"Content-Type", "video/mp4"}]
			}
		]		
		uploader(@method, request, form) |> status_code
	end

	defp upload_resource_builder(object, action) do
    @host <> "/" <> @version <> "/" <> object <> "/" <> "#{action}.json"
	end
end
