defmodule HelpersTest do
	use ExUnit.Case
	import Tweetex.Helpers

	doctest Tweetex.Helpers

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
			assert [{"id", "123"}] == tuple_pairs("id||123")
		end

		test "one string" do
			assert [{"id"}] == tuple_pairs("id")
		end

		test "nothing passed" do
			assert [] == tuple_pairs()
		end
	end

	describe "encode params" do
		test "takes params and returns json" do
			assert "[\"big\",\"think\"]" == encode_params(["big", "think"])
		end
	end

	describe "form data" do
		test "build form data for post" do
			form_data = %{
				data: "adsf",
        extension: "mp4",
        media_id: 1234,
        mime: "vidoe/mp4",
        segment: "adsf"
			}
			assert form(form_data) == [
				{"media", "adsf",
			 	{"form-data",
				[
					{"name", "\"media\""},
					{"filename", "\"adsf.mp4\""},
					{"media_id", 1234},
					{"command", "APPEND"},
					{"segment_index", "adsf"}
				]}, [{"Content-Type", "vidoe/mp4"}]}
			]
		end
	end
end
