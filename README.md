# TweetEx

Using HttPoison and Oauther to put together a lightweight twitter client.  

# Development Setup
Build:
```
  ./build.sh
```

Run:

**Add an .env file with the following**

```
# .env

TWTAPI_CONSUMER_KEY=KEY
TWTAPI_CONSUMER_SECRET=SECRET
TWTAPI_ACCESS_TOKEN=TOKEN
TWTAPI_ACCESS_TOKEN_SECRET=TOKEN_SECRET
```

Then....

```
./run.sh  # Will load up iex console
```

# Installation

* Get a shell on the docker container.
```
docker run --env-file=.env  -it -v `pwd`:/app elixir-tweet bash
```

* run 
```
mix escript.build # This will generate a binary
```

You should see a file called tweetex

# Usage

## Commandline Options:
```
--method # Http method for the call.
--resource # The API resource that is needed.`
--action # The API action to be taken on the call.
--params # JSON payload to be sent to the API.
```

## Examples:

Grab Favorites: 

```
./tweetex --method "get" --resource "favorites" --action "list" --params "screen_name=ridingwithrails"
```

Post a tweet!

```
./tweetex --method "post" --resource "statuses" --action "update" --params "status||Been thinking about this alog||media_ids||1186511864487743489"
```

Get Trends
```
./tweetex --method "get" --resource "trends" --action "available"

```

### Upload Media 

The command will upload the file in chunks and then return a media id for use in a tweet.

```
./tweetex --method "post" --resource "media" --action "upload" --file "test.mp4"
```


