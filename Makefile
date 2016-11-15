# http://unix.stackexchange.com/a/217308/86046
.DEFAULT_GOAL := all

run_unit_tests=python3 -m unittest discover -s test/unit/ -p '*_test.py'
run_integration_tests=python3 -m unittest discover -s test/integration/ -p '*_test.py'

# In order to run one python test:
# python3 test/integration/dev_tools_test.py IntegrationSuite.test_install_docker

.PHONY: build
build:
	docker build -t dotfiles-test -f Dockerfile.test .

.PHONY: unit
unit: build
	docker run --rm -v $(shell pwd):/root/.dotfiles dotfiles-test $(run_unit_tests)

.PHONY: integration
integration: build
	docker run --rm -v $(shell pwd):/root/.dotfiles dotfiles-test $(run_integration_tests)

.PHONY: interactive
interactive: build
	docker run --rm -it -v $(shell pwd):/root/.dotfiles dotfiles-test bash

.PHONY: all
all: build unit integration

