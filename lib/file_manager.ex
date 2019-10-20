defmodule Tweetex.FileManager do  	
	@stage  "./stage"
	@output "./tmp"

	def io(), do: Application.get_env(:tweetex, :io)

	def file_size(file) do
		case io.stat(file) do
			 {:ok, %{size: size}} -> size
			 {:error, error} -> "Woops got an Error #{error}"
	  end
	end

	def split(file)  do
		output_dir = split_directory(file)
		File.stream!("#{@stage}/#{file}", [],  4999990) 			 
			|> Stream.with_index 
			|> Stream.each(		
					fn({data, chunk_id}) -> {:ok, file} = File.open("#{output_dir}/#{chunk_id}.tmp",[:write] )
						IO.binwrite(file, data)
					end) 
			|> Stream.run()
		output_dir		
	end

	def split_append(media_id, file) do		
		IO.puts "Spliting #{file} into chunks"
		output_dir = split(file) 		
		get_range(output_dir)
			|> Enum.each(fn segment -> IO.puts segment end)
		File.rm_rf output_dir	
	end

	def split_directory(file) do
		case File.mkdir("#{@output}/#{file}") do
			:ok -> "#{@output}/#{file}"
			:error -> raise "Unable to create output dir for file"
		end
	end

	def join(finalfile) do
		{:ok, finished_file} = File.open("./#{finalfile}", [:write])
		output_dir = "#{@output}/#{finalfile}"
		get_range(output_dir)
			|> Enum.each(fn file_name -> stitch(finished_file, output_dir, file_name) end)
		File.close(finished_file)
	end

	def stitch(final_file, output_dir, chunk )do
		file = read(output_dir, chunk)
		IO.binwrite(final_file, file)	
	end

	def read(output_dir, chunk) do
		{:ok, file} = File.read("#{output_dir}/#{chunk}.tmp")
		file
	end

	@doc """

	extension returns file extension from a file.

	iex(1)> Tweetex.FileManager.extension "cookoo.png"
	"png"

	iex(1)> Tweetex.FileManager.extension "cookoo.gif"
	"gif"

	iex(1)> Tweetex.FileManager.extension "cookoo"
	"cookoo"

	"""
	def extension(file) do
		String.split(file, ".")	|> List.last
	end

	def get_range(path) do	
		{:ok, files} = File.ls(path) 
		file_count = Enum.count(files) 
		(0..(file_count - 1) )
	end
end
