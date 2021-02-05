GREEN = \033[0;32m
YELLOW = \x1b[33m
NC = \033[0m

region?=europe-west1
runtime?=python38
target?=removeBg

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
## Deploy function
deploy:
	gcloud functions deploy ${target} --region=${region} --runtime=${runtime} --trigger-http --allow-unauthenticated

## Run function_framework local
local: 
	env/bin/functions_framework --target=${target}

