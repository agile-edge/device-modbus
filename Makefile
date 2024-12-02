.PHONY: build test unittest lint clean prepare update docker

PLATFORM=linux/amd64,linux/arm64,linux/arm/v7
GO_PROXY=https://goproxy.cn,direct

MICROSERVICES=cmd/device-modbus

.PHONY: $(MICROSERVICES)

ARCH=$(shell uname -m)

DOCKERS=docker_device_modbus_go
.PHONY: $(DOCKERS)

VERSION=$(shell (git branch --show-current | sed 's/^release\///' | sed 's/^v//') || echo 0.0.0)
#DOCKER_TAG=$(VERSION)-$(shell git log -1 --format=%h)
DOCKER_TAG=$(VERSION)

GIT_SHA=$(shell git rev-parse HEAD)

SDKVERSION=$(shell cat ./go.mod | grep 'github.com/agile-edge/device-sdk-go/v3 v' | awk '{print $$2}')
GOFLAGS=-ldflags "-X github.com/agile-edge/device-modbus.Version=$(VERSION) \
                  -X github.com/agile-edge/device-sdk-go/v3/internal/common.SDKVersion=$(SDKVERSION)" \
                   -trimpath -mod=readonly

build: $(MICROSERVICES)

build-nats:
	make -e ADD_BUILD_TAGS=include_nats_messaging build

tidy:
	go mod tidy

cmd/device-modbus:
	CGO_ENABLED=0 go build -tags "$(ADD_BUILD_TAGS)" $(GOFLAGS) -o $@ ./cmd

unittest:
	go test ./... -coverprofile=coverage.out

lint:
	@which golangci-lint >/dev/null || echo "WARNING: go linter not installed. To install, run make install-lint"
	@if [ "z${ARCH}" = "zx86_64" ] && which golangci-lint >/dev/null ; then golangci-lint run --config .golangci.yml ; else echo "WARNING: Linting skipped (not on x86_64 or linter not installed)"; fi

install-lint:
	sudo curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $$(go env GOPATH)/bin v1.54.2

test: unittest lint
	go vet ./...
	gofmt -l $$(find . -type f -name '*.go'| grep -v "/vendor/")
	[ "`gofmt -l $$(find . -type f -name '*.go'| grep -v "/vendor/")`" = "" ]
	./bin/test-attribution-txt.sh
	
clean:
	rm -f $(MICROSERVICES)

docker: $(DOCKERS)

docker_device_modbus_go:
	docker buildx build --platform $(PLATFORM) \
		--build-arg ADD_BUILD_TAGS=$(ADD_BUILD_TAGS) \
		--build-arg GO_PROXY=$(GO_PROXY) \
		--label "git_sha=$(GIT_SHA)" \
		--push \
		-t ccr.ccs.tencentyun.com/agile-edge/device-modbus:$(DOCKER_TAG) \
		.

	docker buildx build --platform $(PLATFORM) \
		--build-arg ADD_BUILD_TAGS=$(ADD_BUILD_TAGS) \
		--build-arg GO_PROXY=$(GO_PROXY) \
		--label "git_sha=$(GIT_SHA)" \
		--push \
		-f Dockerfile.alpine
		-t ccr.ccs.tencentyun.com/agile-edge/device-modbus:$(DOCKER_TAG)-alpine \
		.

docker-nats:
	make -e ADD_BUILD_TAGS=include_nats_messaging docker
