# vim: set noet ci pi sts=0 sw=4 ts=4 :
# http://www.gnu.org/software/make/manual/make.html
# http://linuxlib.ru/prog/make_379_manual.html
########################################################################
SHELL := $(shell which bash)
DEBUG ?= 0

CURRENT_DIR ?= $(shell readlink -m $(CURDIR))

SUDO ?= sudo
DOCKER ?= docker
DOCKER_COMPOSE ?= docker-compose
########################################################################
# Default variables
########################################################################
-include .env
export
########################################################################

build: \
		terraform
	( \
		cd terraform && \
		$(SUDO) $(DOCKER) build -t terraform:latest . \
	)

terraform:
	git clone https://github.com/hashicorp/terraform $@

bin:
	mkdir -p $@

.PHONY: copy
copy: \
		bin
	$(SUDO) $(DOCKER) run -d terraform:latest && \
	$(SUDO) $(DOCKER) cp $$($(SUDO) $(DOCKER) ps -q -f ancestor=terraform:latest|head -1):/go/bin/terraform $</ && \
	$(SUDO) $(DOCKER) kill $$($(SUDO) $(DOCKER) ps -q -f ancestor=terraform:latest|head -1)
