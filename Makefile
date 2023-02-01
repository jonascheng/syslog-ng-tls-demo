.DEFAULT_GOAL := help

SERVER_IP?=192.168.1.10

.PHONY: setup
setup: ## setup go modules
	cd syslog-client && go mod tidy

.PHONY: setup-syslog-ng-key
setup-syslog-ng-key: ## generate syslog-ng server cert
	mkdir -p syslog-ca && rm -f syslog-ca/*
	echo "subjectAltName=DNS:${SERVER_IP},IP:${SERVER_IP}" > ./server-ext.cnf
	SITE_NAME=${SERVER_IP} ./provision/cert-gen.sh
	mv endentity-ca.* syslog-ca

.PHONY: run-syslog-ng-tcp
run-syslog-ng-tcp: ## runs syslog-ng via tcp
	docker run --rm -it -p 601:601 -p 6514:6514 --name syslog-ng \
		-v "`pwd`/syslog-conf/:/etc/syslog-ng/"	\
		-v "`pwd`/syslog-ca/:/etc/syslog-ca/"	\
		-v "/tmp/log/:/var/log/" \
		balabit/syslog-ng:latest -edv

.PHONY: run-loggen-tcp
run-loggen-tcp: ## runs syslog loggen via tcp
	loggen -i -S -P ${SERVER_IP} 601

.PHONY: run-openssl-tls
run-openssl-tls: ## runs syslog client via tls
	openssl s_client -connect ${SERVER_IP}:6514

.PHONY: run-syslog-client-tcp
run-syslog-client-tcp: ## runs syslog client via tcp
	cd syslog-client && go run main.go

.PHONY: help
help: ## prints this help message
	@echo "Usage: \n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
