#!/bin/bash
set -e

docker buildx build \
	--platform linux/amd64 \
	-t ghcr.io/compilercomplied/claude-agent:latest \
	--push .
