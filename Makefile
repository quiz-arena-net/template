.PHONY: install install-buf install-protoc-gen-go install-protoc-gen-connect-go check format generate test build run clean help

.DEFAULT_GOAL = build
SERVICE_NAME = template

# Install all tools
install: install-buf install-protoc-gen-go install-protoc-gen-connect-go
	@echo "All tools installed successfully!"

install-buf:
	@echo "Installing buf..."
	go install github.com/bufbuild/buf/cmd/buf@latest

install-protoc-gen-go:
	@echo "Installing protoc-gen-go..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

install-protoc-gen-connect-go:
	@echo "Installing protoc-gen-connect-go..."
	go install connectrpc.com/connect/cmd/protoc-gen-connect-go@latest

# Check if tools are installed and show versions
check:
	@echo "Checking installed tools..."
	@which buf >/dev/null 2>&1 && echo "✓ buf v$$(buf --version)" || echo "✗ buf not found"
	@which protoc-gen-go >/dev/null 2>&1 && echo "✓ $$(protoc-gen-go --version)" || echo "✗ protoc-gen-go not found"
	@which protoc-gen-connect-go >/dev/null 2>&1 && echo "✓ protoc-gen-connect-go v$$(protoc-gen-connect-go --version)" || echo "✗ protoc-gen-connect-go not found"

format:
	@echo "Formatting protobuf definitions..."
	buf format -w
	@echo "Formatting Go source files..."
	goimports -w .

generate:
	@echo "Generating protobuf/connect code with buf..."
	buf generate

test: generate
	@echo "Running Go tests..."
	go test ./...

build: generate
	@echo "Building Go binaries..."
	mkdir -p bin
	go build -o bin/$(SERVICE_NAME) ./cmd/server

run:
	@echo "Starting $(SERVICE_NAME) service..."
	go run ./cmd/server

clean:
	@echo "Cleaning generated code..."
	rm -rf internal/gen
	@echo "Cleaning generated binaries..."
	rm -rf bin

help:
	@echo "Available targets:"
	@echo "  install                            - Install all tools"
	@echo "  install-buf                        - Install buf only"
	@echo "  install-protoc-gen-go              - Install protoc-gen-go only"
	@echo "  install-protoc-gen-connect-go      - Install protoc-gen-connect-go only"
	@echo "  check                              - Check if tools are installed"
	@echo "  format                             - Format proto and Go source files"
	@echo "  generate                           - Generate protobuf/connect code"
	@echo "  test                               - Run Go tests"
	@echo "  build                              - Build packages"
	@echo "  run                                - Build and start the service locally"
	@echo "  clean                              - Clean generated code and binaries"
	@echo "  help                               - Show this help message"
