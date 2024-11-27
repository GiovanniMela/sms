.PHONY: build
build:
	docker compose build web

.PHONY: terminal
terminal:
	docker compose run --rm --entrypoint /bin/ash web

.PHONY: console
console:
	docker compose run --rm web bundle exec rails c

.PHONY: server
server:
	docker compose up web

.PHONY: test
test:
	RAILS_ENV=test docker compose run --rm web bundle exec rspec ${ARGS} -p

.PHONY: rubocop
rubocop:
	docker compose run --rm web bundle exec rubocop ${ARGS}

.PHONY: clean
clean: worker_clean
	docker compose down
	docker rmi $$(docker images -q "sms*")
