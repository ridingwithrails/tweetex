defmodule HelpersTest do
	use ExUnit.Case
	import Tweetex.Helpers

	describe "Tweet Media Category Mapper" do
		test "video matching" do	
			assert media_category("test.mp4") == "tweet_video"
		end

		test "no match" do
			assert media_category("cheese") == nil
		end
	end
end
