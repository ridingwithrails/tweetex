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


	describe "Params parse to tuple pairs" do
		test "two strings" do
			assert [{"id", "123"}] == tuple_pairs("id=123")
		end

		test "one string" do
			assert [{"id"}] == tuple_pairs("id")
		end

		test "nothing passed" do
			assert [] == tuple_pairs
		end
	end
end
