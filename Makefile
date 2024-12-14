NAME ?= calendagostinho
DESCRIPTION ?= Calendagostinho

REGISTRY ?= registry.gitlab.com

VERSION ?= $(shell git describe --tags --exact-match 2>/dev/null || git symbolic-ref -q --short HEAD | tr / -)
COMMIT_HASH ?= $(shell git rev-parse --short HEAD 2>/dev/null)
COMMIT_HASH_LONG ?= $(shell git rev-parse HEAD 2>/dev/null)

REMOTE ?= $(shell git ls-remote --get-url 2>/dev/null)
GIT_SERVICE ?= $(shell echo "$(REMOTE)" | cut -d ":" -f1 | cut -d "@" -f2)
SOURCE ?= https://$(GIT_SERVICE)/$(shell echo $(REMOTE) | cut -d ":" -f2)
URL ?= $(shell echo "$(SOURCE)" | rev | cut -c 5- | rev)
MAIN_BRANCH ?= $(shell git symbolic-ref refs/remotes/origin/HEAD | cut -d "/" -f4)

# checks if the repository was cloned via https or ssh
# them extracts the repo path depending on how you cloned the repository
ifeq ($(shell echo $(REMOTE) | head -c 5 ), https)
	REPO_PATH = $(shell echo $(REMOTE) | sed 's/.*\.com\///' | rev | cut -c 5- | rev )
else
	REPO_PATH = $(shell echo $(REMOTE) | cut -d ":" -f2 | rev | cut -c 5- | rev)
endif

PROJECT_REGISTRY ?= $(REGISTRY)/$(REPO_PATH)

DATE_FMT = +%FT%TZ # ISO 8601
BUILD_DATE ?= $(shell date "$(DATE_FMT)") # "-u" for UTC time (zero offset)

BUILD_DIR ?= build
LDFLAGS += -X main.version=$(VERSION) -X main.commitHash=$(COMMIT_HASH) -X main.buildDate=$(BUILD_DATE)

OC_LABELS += --label org.opencontainers.image.created="$(BUILD_DATE)"
OC_LABELS += --label org.opencontainers.image.description="$(DESCRIPTION)"
OC_LABELS += --label org.opencontainers.image.revision="$(COMMIT_HASH_LONG)"
OC_LABELS += --label org.opencontainers.image.source="$(SOURCE)"
OC_LABELS += --label org.opencontainers.image.title="$(NAME)"
OC_LABELS += --label org.opencontainers.image.url="$(URL)"
OC_LABELS += --label org.opencontainers.image.version="$(VERSION)"
OC_LABELS += --label org.opencontainers.image.vendor="Aria"
OC_LABELS += --label org.opencontainers.image.authors="$(URL)/-/graphs/$(MAIN_BRANCH)"

# in case some problems raise with NGINX serving tanstack router 404 routes
# change back to Caddy deployment at deployment/caddy/Dockerfile
DOCKER_FILE ?= deployments/nginx/Dockerfile

.DEFAULT_GOAL: help
default: help

.PHONY: build
build: deps compile

.PHONY: deps
deps:
	npm install

.PHONY: compile
compile:
	npm run build

.PHONY: run
run:
	npm run dev

.PHONY: run-all
run-all:
	npm run dev --host 0.0.0.0

.PHONY: start
start:
	npm start

.PHONY: test
test:
	npm test

.PHONY: lint
lint:
	npm run lint

.PHONY: lint-fix
lint-fix:
	npm run lint:fix

.PHONY: image
image: ## Build container image
	docker build --platform linux/amd64 --tag $(PROJECT_REGISTRY):$(VERSION) -f $(DOCKER_FILE) $(OC_LABELS) .
	# docker build --tag $(PROJECT_REGISTRY):$(VERSION) -f $(DOCKER_FILE) $(OC_LABELS) .

.PHONY: push
push: ## Push container image
	docker push $(PROJECT_REGISTRY):$(VERSION)

.PHONY: help
help:
	@printf -- "Aria UI\n"