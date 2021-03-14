#!/bin/sh

registerService()
{
  curl --request PUT \
    --url http://consul-server-bootstrap:8500/v1/agent/service/register \
    --header 'Content-Type: application/json' \
    --data '{
  	"Name": "web-server",
  	"Id": "web-server-'"$1"'",
  	"Address": "web_server_'"$1"'",
  	"Tags": ["strip=/web-server"],
  	"Port": 80,
  	"Check": {
  		"HTTP": "http://web_server_'"$1"':80",
  		"Interval": "5s",
  		"Timeout": "1s"
  	}
  }'
}

# Register web_server_0 in consul
registerService 0
# Register web_server_1 in consul
registerService 1