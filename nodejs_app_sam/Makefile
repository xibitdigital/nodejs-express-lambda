ENVIRONMENT=dev
S3_BUCKET=xibitdigital-todo-app-${ENVIRONMENT}
INPUT_FILE=sam-template.yaml
OUTPUT_FILE=sam-template-output.yaml
STAGE_NAME=${ENVIRONMENT}
STACK_NAME=todo-app-${ENVIRONMENT}
API_GATEWAY_URL=$(aws cloudformation describe-stacks --stack-name ${STACK_NAME} --query 'Stacks[0].Outputs[0].OutputValue' --output text)

.PHONY: build sam-deploy

all: install build

install:
	pip3 install aws-sam-cli
	pip3 install awscli-local
	npm i

build: 
	cd src
	npm ci
	npm run-script lint
	npm prune --production

upload-swagger:
	aws s3 cp swagger.yaml s3://${S3_BUCKET}/swagger.yaml

sam-deploy:
	aws cloudformation package --template-file ${INPUT_FILE} \
                           --output-template-file ${OUTPUT_FILE} \
                           --s3-bucket ${S3_BUCKET}
	aws cloudformation deploy --template-file ${OUTPUT_FILE} \
                          --stack-name ${STACK_NAME} \
                          --parameter-overrides StageName=${STAGE_NAME} S3BucketName=${S3_BUCKET} \
                          --capabilities CAPABILITY_IAM
