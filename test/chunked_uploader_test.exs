defmodule ChunkedUploaderTest do
	import Tweetex.ChunkedUploader
	use ExUnit.Case

	describe "Processing state from Service" do
		test "returns state -- success" do
			{:ok, payload} = {:ok, make_payload("succeeded")}     
			assert "succeeded" == state(payload)
		end

		test "return state -- pending" do
			{:ok, payload} = {:ok, make_payload("pending")}     
			assert "pending" == state(payload)
		end
	end

	describe "Checks if Processing" do
		test "returns true if processing" do
			assert true == processing?{:ok, make_payload("pending")} 
		end

		test "returns false if processing completes" do
			assert false == processing?{:ok, make_payload("succeeded")} 
		end
	end

	def make_payload(state) do
		%{
			"expires_after_secs" => 86398,
			"media_id" => 1188189841961304064,
			"media_id_string" => "1188189841961304064",
			"media_key" => "16_1188189841961304064",
			"processing_info" => %{"progress_percent" => 100, "state" => state},
			"size" => 323646
		}
	end	
end

