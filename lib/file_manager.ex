defmodule Tweetex.FileManager do  
	@stage  "./stage"
	@output "./tmp"
	
	def split(file)  do
		output_dir = split_directory(file)
		File.stream!("#{@stage}/#{file}", [],  4999990) 			 
			|> Stream.with_index 
			|> Stream.each( 
					fn({data, chunk_id}) -> {:ok, file} = File.open("#{output_dir}/#{chunk_id}.tmp",[:write] )
					IO.binwrite(file, data)
				end) 
			|> Stream.run()
	end

	def split_directory(file) do
		case File.mkdir("#{@output}/#{file}") do
			:ok -> "#{@output}/#{file}"
			:error -> raise "Unable to create output dir for file"
		end
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
