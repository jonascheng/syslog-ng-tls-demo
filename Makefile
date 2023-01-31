.DEFAULT_GOAL := help

.PHONY: setup
setup: ## setup go modules
	cd syslog-client && go mod tidy

.PHONY: run-syslog-ng-tcp
run-syslog-ng-tcp: ## runs syslog ng via tcp
	docker run --rm -it -p 601:601 --name syslog-ng \
		-v "/tmp/log/:/var/log/" \
		balabit/syslog-ng:latest -edv

.PHONY: run-loggen-tcp
run-loggen-tcp: ## runs syslog loggen via tcp
	loggen -i -S -P localhost 601

.PHONY: run-syslog-client-tcp
run-syslog-client-tcp: ## runs syslog client via tcp
	cd syslog-client && go run main.go

.PHONY: help
help: ## prints this help message
	@echo "Usage: \n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
