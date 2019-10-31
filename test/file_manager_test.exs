defmodule FileManagerTest do
	use ExUnit.Case
	import Mox
	import Tweetex.FileManager

	doctest Tweetex.FileManager

	setup :verify_on_exit!

	describe "IO actions" do
		test "Get file size " do
      Tweetex.IoBehaviorMock
        |> expect(:stat, fn _path ->
          {:ok, %{size: 21} }
        end)
			size = file_size("a file")
			assert size == 21
		end
		
		test "Failed to get fiile" do
			Tweetex.IoBehaviorMock
        |> expect(:stat, fn _path ->
          {:error, "eeonent" }
        end)
			assert_raise RuntimeError, "Got the following error eeonent",  fn ->
			 file_size("a file")
			end
		end
	end
end
