.PHONY: up localstack-down localstack-up  _zip-solution _create-function

all: install localstack-down localstack-up  _zip-solution _create-function

install:
	pip3 install aws-sam-cli
	pip3 install awscli-local
	pip3 install terraform-local
	npm i

localstack-up:
	docker-compose up -d

localstack-down:
	docker-compose down

_create-function:
	awslocal lambda create-function \
    --function-name worker \
    --zip-file fileb://index.zip \
    --handler index.handler \
	--runtime nodejs16.x \
	--role arn:aws:iam::000000000000:role/lambda-ex \
	--environment file://environment.json

_zip-solution:
	rm -rf ./index.zip
	zip ./index.zip  ./src/*.js

_delete-function:
	awslocal lambda delete-function \
    --function-name worker

upload-function:
	$(MAKE) _zip-solution
	$(MAKE) _delete-function
	$(MAKE) _create-function

run-function:
	awslocal lambda invoke --function-name worker /dev/stdout
