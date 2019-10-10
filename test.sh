echo "Get with params"
./tweetex --method "get" --resource "favorites" --action "list" --params "screen_name=ridingwithrails"

echo "Get without params"
./tweetex --method "get" --resource "trends" --action "available"