#!/usr/bin/env bash
set -e

# Resolve the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Configuring docker-9router environment..."

# Detect repository owner UID and GID (supports Linux, macOS, and fallback to current user)
if stat -c '%u' "$SCRIPT_DIR" >/dev/null 2>&1; then
    REPO_UID=$(stat -c '%u' "$SCRIPT_DIR")
    REPO_GID=$(stat -c '%g' "$SCRIPT_DIR")
elif stat -f '%u' "$SCRIPT_DIR" >/dev/null 2>&1; then
    REPO_UID=$(stat -f '%u' "$SCRIPT_DIR")
    REPO_GID=$(stat -f '%g' "$SCRIPT_DIR")
else
    REPO_UID=$(id -u)
    REPO_GID=$(id -g)
fi

echo "==> Detected repository owner UID: ${REPO_UID}, GID: ${REPO_GID}"

# Copy .env.example to .env if .env doesn't exist
if [ ! -f .env ]; then
    echo "==> .env file not found. Creating .env from .env.example..."
    cp .env.example .env
fi

# Function to update or append a key=value in .env
update_env_var() {
    local key="$1"
    local value="$2"
    if grep -q "^${key}=" .env; then
        sed -i "s|^${key}=.*|${key}=${value}|" .env
    else
        echo "${key}=${value}" >> .env
    fi
}

update_env_var "NODE_USER_UID" "${REPO_UID}"
update_env_var "NODE_USER_GID" "${REPO_GID}"

# Ensure data directory exists with appropriate permissions
mkdir -p data
if [ -w data ]; then
    chown -R "${REPO_UID}:${REPO_GID}" data 2>/dev/null || true
fi

echo "==> Successfully updated .env with:"
echo "    NODE_USER_UID=${REPO_UID}"
echo "    NODE_USER_GID=${REPO_GID}"
echo ""
echo "==> Setup complete! You can now start or rebuild the service with:"
echo "    docker compose up -d --build"
