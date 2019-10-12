defmodule Tweetex.IoBehavior do  
	@moduledoc false
	@callback stat(String.t()) :: tuple()
end