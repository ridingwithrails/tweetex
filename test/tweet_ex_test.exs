defmodule TweetexTest do
  use ExUnit.Case
  import Mox
  doctest Tweetex

  describe "Handling params" do 
    test "Bad options passed" do
      assert Tweetex.main([:nothing]) == "In correct params sent"
    end

    test "Options without params " do
      ClientBehaviorMock
      |> expect(:fetcher, fn _method, _request ->
        {:ok, "good"}
      end)


      result = Tweetex.main(["--method", "get", "--resource", "statuses", "--action", "lookup"]) 
      assert result == {:ok, %{good: true}}
    end
  end  
end
