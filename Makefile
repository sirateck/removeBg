GREEN = \033[0;32m
YELLOW = \x1b[33m
NC = \033[0m

region?=europe-west1
runtime?=python38
GOOGLE_FUNCTION_TARGET?=removeBg
packageName?=removebg
imageName?=${projectId}/${packageName}
runImage?=gcr.io/${projectId}/python3-dev-run-image

default:help;
## Display this help dialog
help:
	@echo "${YELLOW}Usage:${NC}\n  make [command]:\n\n${YELLOW}Available commands:${NC}"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${GREEN}%-30s${NC} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

BUILD_FLAGS = --builder=gcr.io/buildpacks/builder:v1 \
	--run-image=${runImage} \
	--env=GOOGLE_FUNCTION_SIGNATURE_TYPE=http \
	--env=GOOGLE_FUNCTION_TARGET=${GOOGLE_FUNCTION_TARGET} \
	--env=GOOGLE_RUNTIME=python
PUBLISH_FLAGS = ${BUILD_FLAGS} --publish gcr.io/${imageName}

## Build on container with buildpacks
build:
	docker build -t ${runImage} -f run.Dockerfile .
	pack build ${imageName} ${BUILD_FLAGS}

## Publish image used to run gcloud run container
publish-run-image:
	# DOCKER_BUILDKIT used to use .dockerignore by Dockerfile name
	DOCKER_BUILDKIT=1 docker build -t ${runImage} -f run.Dockerfile .
	docker push ${runImage}

## Build and publish
publish:
	# docker build -t ${runImage} -f run.Dockerfile .
	pack build ${PUBLISH_FLAGS}

## Deploy function
deploy:
	gcloud run deploy ${packageName} --image=gcr.io/${imageName} --platform managed --region=${region} --allow-unauthenticated --memory 512M
	# gcloud functions deploy ${GOOGLE_FUNCTION_TARGET} --region=${region} --runtime=${runtime} --trigger-http --allow-unauthenticated

## Run function_framework local
run-local:
	env/bin/functions_framework --target=${GOOGLE_FUNCTION_TARGET}
## Run function in docker container
run-local-docker: build
	docker run --rm -p 8080:8080 ${imageName}

