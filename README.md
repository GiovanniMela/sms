# README

This services consumes a (mostly longer) text message and splits it into smaller parts for later sending to another client that can only consume smaller parts.

## Endpoint
This services provides one **POST** endpoint reachable under the following resource:

* `/api/v1/send_messages`

The endpoint accepts the following **json** object:

* `message: "String"`

## Dev setup
The setup assumes that on your development machine a recent version of `docker` and `docker-compose` is installed and configured.

* Initially run `make setup`

* Last but not least to start the service run `make server` to start a server listening on PORT 3000

Please check out `Makefile` for other commands.
