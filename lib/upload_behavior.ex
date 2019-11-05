defmodule Tweetex.UploadBehavior do  
	@moduledoc false
	@callback work(String.t()) :: tuple()
end
