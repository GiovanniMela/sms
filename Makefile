-include env.development

.PHONY: setup
setup: build db_setup

.PHONY: build
build:
	if [ ! -f "env.development" ]; then cp env.template env.development; fi;
	docker compose build web

db_setup:
	docker compose run --rm web bundle exec rails db:create db:migrate
	RAILS_ENV=test docker compose run --rm web bundle exec rails db:create db:migrate

db_reset:
	docker compose run --rm web bundle exec rails db:migrate:reset
	RAILS_ENV=test docker compose run --rm web bundle exec rails db:migrate:reset

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
clean:
	docker compose down
	docker volume rm sms_pgdata
	docker rmi $$(docker images -q "sms*")
