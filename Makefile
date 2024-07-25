MAKEFLAGS += -s

REGISTRY=ghcr.io/brokerua
APP=${shell basename ${shell git remote get-url origin}}
VERSION=${shell git describe --tags --abbrev=0}-${shell git rev-parse --short HEAD}

VALID_COMMANDS=linux-amd64 linux-386 linux-arm linux-arm64 linux-mips linux-mips64 linux-ppc64 linux-ppc64le linux-s390x windows-amd64 windows-386 darwin-amd64 darwin-arm64

TARGET_EXEC:=kbot
BUILD_DIR:=./build
SRC_DIR:=./

format:
	gofmt -s -w ${SRC_DIR}

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGET_OS} GOARCH=${TARGET_ARCH} go build -v -o ${BUILD_DIR}/${TARGET_EXEC} -ldflags "-X=github.com/brokerUA/kbot/cmd.appVersion=${VERSION}"

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGET_ARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGET_ARCH}

%:
	if echo "${VALID_COMMANDS}" | grep -wq "$*"; then \
  		export TARGET_OS=$(word 1, $(subst -, ,$(*))); \
        export TARGET_ARCH=$(word 2, $(subst -, ,$(*))); \
		$(MAKE) image; \
		$(MAKE) push; \
		$(MAKE) clean; \
	else \
		echo ">>> Invalid command: $*. \n>>> Use one of: ${VALID_COMMANDS}"; \
		exit 1; \
	fi
	echo ">>> Build for ${*}"

.PHONY: clean
clean:
	rm -rf ${BUILD_DIR}
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGET_ARCH} -f || true