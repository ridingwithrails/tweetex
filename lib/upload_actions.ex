defmodule Tweetex.UploadActions do
	import Tweetex.Oauth
	import Tweetex.Helpers
	import Tweetex.Client
	import Tweetex.Payload
	import Tweetex.FileManager

	@stage  "./stage"
	@host "https://upload.twitter.com/"
	@version "1.1"
	@method "post"


	def init(file) do
		params = init_data(file)
			|> encode_params
			|> parse_params
		resource = resource_builder("media", "upload", @host)
		request = build_request(@method, resource, params)
		# HTTPoison.post(request.resource, [], request.header, params: request.params) |> body
		fetcher(@method, request)	|> body
	end

	def init_data(file) do
		[
			"media_type", MIME.from_path("#{file}"),
		  "media_category", media_category("#{file}"),
			"total_bytes", file_size("./stage/#{file}"),
			"command", "INIT"
		]
	end

	def finalize(media_id) do
		params = finalize_data(media_id)
			|> encode_params
			|> parse_params
		resource = resource_builder("media", "upload", @host)
		request = build_request(@method, resource, params)
		fetcher(@method, request)	|> body
	end

	def finalize_data(media_id) do
		[
			"media_id", Integer.to_string(media_id),
			"command", "FINALIZE"
		]
	end

	def status(media_id) do
		params = status_data(media_id)
			|> encode_params
			|> parse_params
		resource = resource_builder("media", "upload", @host)
		request = build_request("get", resource, params)
		fetcher("get", request) |> body
	end

	def status_data(media_id) do
		[
			"command", "STATUS",
			"media_id", media_id
		]
	end

	def split(file, media_id) do
		ext = extension(file)
		mime = MIME.from_path("#{file}")		
		File.stream!("#{@stage}/#{file}", [],  4999990)
			|> Stream.with_index
			|> Stream.each(
					fn({data, segment}) -> append(media_id, segment, data, ext, mime)
					end)
			|> Stream.run()
	end

	def append_data(media_id, segment) do
		[
			"media_id", media_id,
			"command", "APPEND",
			"segment_index", segment,
		]
	end

	def append(media_id, segment, data, ext, mime) do
		params = append_data(media_id, segment)
			|> encode_params
			|> parse_params
		resource = resource_builder("media", "upload", @host)
		request = build_request(@method, resource, params)
		form_data = %{
			data: data, 
			segment: segment,
			extension: ext,  
			mime: mime,
			media_id: media_id
		}
		fetcher(@method, request, form(form_data)) |> status_code
	end
end
