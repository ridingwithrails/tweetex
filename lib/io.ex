defmodule Tweetex.Io do
	@behaviour Tweetex.Io
	def stat(path) do
		File.stat(path)
	end	
end