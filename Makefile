run_ansible_cmd=ansible-playbook ansible.yml -i 'localhost,' -c local

install:
	sudo pip install ansible
	ansible-galaxy install geerlingguy.docker
	$(run_ansible_cmd)

build:
	docker build -t dotfiles-test -f Dockerfile.test .

test: build
	docker run --rm -v $(shell pwd):/home/ronaldo/.dotfiles dotfiles-test $(run_ansible_cmd)

# Interactively run tests in a bash session
test-i: build
	docker run --rm -it -v $(shell pwd):/home/ronaldo/.dotfiles dotfiles-test bash
