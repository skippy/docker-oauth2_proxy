NAME = skippy/oauth2_proxy
VERSION = 2.0.1

all: build

build:
	docker build -t $(NAME):$(VERSION) .

test:
	docker run $(NAME):$(VERSION) --version

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	curl -H "Content-Type: application/json" --data '{"build": true};' -X POST https://registry.hub.docker.com/u/skippy/oauth2_proxy/trigger/dd48aebe-e26b-430d-9810-4cab5d3f1813/
