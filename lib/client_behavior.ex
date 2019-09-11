defmodule Tweetex.ClientBehavior do  
	@moduledoc false
	@callback fetcher(String.t(), map()) :: tuple()
end
