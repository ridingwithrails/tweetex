defmodule Tweetex.Upload do
	def post(path)  do
		File.stream!(".#{path}", [], 1024) 
			|> Stream.chunk_every(1024)  
			|> Stream.with_index 
			|> Stream.each( 
					fn({data, chunk_id}) -> {:ok, file} = File.open("./lib/output/#{chunk_id}.tmp",[:write] )
					IO.binwrite(file, data)
				end) 
			|> Stream.run()
	end

	def join(path) do
		{:ok, final_file} = File.open("./bigfinal.mp4", [:write])
		{:ok, files} = File.ls("./lib/output/") 
		file_count = Enum.count(files) 
		filename_range = (0..(file_count - 1) )
		Enum.each(filename_range, fn file_name ->
			{:ok, file} = File.read("./lib/output/#{file_name}.tmp")
			IO.binwrite(final_file, file)			
		end)
		File.close(final_file)
	end
end