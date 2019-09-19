defmodule Tweetex.Upload do
	def upload(path)  do
# 		'''
# 		Get size of the file 
# 		{:ok, %{size: size} } = File.stat "test.mp4"


		#Split it into chunks of 1 MB each



File.stream!("./test.mp4", [], 1024) |> Stream.chunk_every(1024)  |> Stream.with_index |> Stream.each( 
	fn({data, chunk_id}) -> {:ok, file} = File.open("./lib/output/#{chunk_id}.tmp",[:write] )
	IO.binwrite(file, data)
end) |> Stream.run()

# 		'''
	end
end