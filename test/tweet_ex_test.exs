defmodule TweetexTest do
  use ExUnit.Case
  import Mox
  doctest Tweetex

  setup :verify_on_exit!

  describe "Handling CLI Args" do
    test "Bad options passed" do
      assert Tweetex.main([:nothing]) == "In correct params sent"
    end

    test "Options without params " do
      Tweetex.ClientBehaviorMock
        |> expect(:fetcher, fn _method, _request ->
          {:ok, %{body: "\"ok\""} }
        end)
      result = Tweetex.main(["--method", "get", "--resource", "statuses", "--action", "lookup"])
      assert result == {:ok, "ok"}
    end

    test "Options with params" do
      Tweetex.ClientBehaviorMock
        |> expect(:fetcher, fn _method, _request ->
          {:ok, %{body: "\"ok\""} }
        end)
      data = ["--method",  "post", "--resource", "statuses", "--action", "update", "--params", "[\"status\", \"Been thinking about this alog\"]"]   
      result = Tweetex.main(data)
      assert result == {:ok, "ok"}
    end

    test "Options for Uploader" do
      data = ["--method",  "post", "--resource", "statuses", "--type", "uploader" ,"--action", "update", "--params", "[\"status\", \"Been thinking about this alog\"]"]   
      result = Tweetex.main(data)
      assert result == {:ok, "ok"}
    end
  end
end
