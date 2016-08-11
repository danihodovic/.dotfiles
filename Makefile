run_integration_tests=python3 -m unittest discover -s test/integration/ -p '*_test.py'

build:
	docker build -t dotfiles-test -f Dockerfile.test .

unit:
	python3 -m unittest discover -s test/unit/ -p '*_test.py'

integration: build
	docker run --rm -v $(shell pwd):/root/.dotfiles dotfiles-test $(run_integration_tests)

interactive: build
	docker run --rm -it -v $(shell pwd):/root/.dotfiles dotfiles-test bash

all: build unit integration

