#!/usr/bin/env bash
set -euo pipefail

# Change these if your container listens on a different port/path.
PORT="${PORT:-8080}"
PATH_CHECK="${PATH_CHECK:-/health}"

# Run the container in the background
CID=$(docker run -d -p 127.0.0.1:${PORT}:${PORT} "${IMAGE}")

# Always clean up the container
cleanup() { docker rm -f "$CID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

# Give it a moment to start
sleep 3

# Probe the endpoint
curl -fsS "http://127.0.0.1:${PORT}${PATH_CHECK}" >/dev/null

echo "Smoke test passed: ${IMAGE} responded on ${PATH_CHECK}"
