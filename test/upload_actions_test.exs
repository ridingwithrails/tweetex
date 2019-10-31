defmodule UploadActionsTest do
	use ExUnit.Case
	import Tweetex.UploadActions
	import Mox
	

	setup :verify_on_exit!

	describe "Requests" do
		test "init request" do  
			Tweetex.IoBehaviorMock
					|> expect(:stat, fn _path ->
						{:ok, %{size: 21} }
					end)
			request =  build_init_request("giphy.gif")
			assert {"total_bytes", 21} = Enum.find(request.params, 
				fn x -> {"total_bytes", 21} == x end)				
		end
	end
end
