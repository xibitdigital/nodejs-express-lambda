SHELL = /bin/sh

.PHONY: install get_aws_account build_local

all: install

install:
	npm i
	brew install pre-commit tflint terraform-docs
	pre-commit install
	pre-commit install-hooks

build_local:
	npm run build

get_aws_account:
	aws sts get-caller-identity

install_modules:
	terraform init

lock_providers:
	terraform providers lock \
		-platform=linux_arm64 \
		-platform=linux_amd64 \
		-platform=darwin_amd64 \
		-platform=windows_amd64

delete_terragrunt_cache:
	find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
