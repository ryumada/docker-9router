# Docker Host-Container UID/GID Synchronization

When containerizing applications with bind-mounted host volumes and non-root execution, ensure the container's non-root user UID and GID match the host repository owner to prevent permission denied errors (`EACCES`).

## Core Principles

1. **Host-Container Permission Mismatch**:
   - Linux bind mounts evaluate permissions using numeric UID/GID.
   - If the host user is not `1000` (common on VPS, CI runners, or secondary users), non-root container users cannot read/write bind-mounted files with strict permissions (e.g., `0600` or owner-only).

2. **Base Image Selection**:
   - Prefer Debian `slim` over Alpine when dynamically reconfiguring users and groups.
   - Debian includes standard GNU shadow utilities (`usermod`, `groupmod`) natively, whereas Alpine BusyBox `adduser`/`addgroup` has differing flags (e.g. no `-m` flag) and may require extra packages.

3. **Dockerfile Pattern**:
   - Define build arguments with default `1000`:
     ```dockerfile
     ARG NODE_USER_UID=1000
     ARG NODE_USER_GID=1000

     RUN if [ "$NODE_USER_UID" != "1000" ] || [ "$NODE_USER_GID" != "1000" ]; then \
             groupmod -g "$NODE_USER_GID" node && \
             usermod -u "$NODE_USER_UID" -g "$NODE_USER_GID" node && \
             chown -R "$NODE_USER_UID":"$NODE_USER_GID" /home/node; \
         fi
     ```

4. **Docker Compose Pattern**:
   - Pass the environment variables as build arguments:
     ```yaml
     build:
       context: .
       args:
         NODE_USER_UID: ${NODE_USER_UID:-1000}
         NODE_USER_GID: ${NODE_USER_GID:-1000}
     ```

5. **Automated Setup Script (`setup.sh`)**:
   - Always offer or implement a cross-platform helper script (`setup.sh`) that detects host directory owner UID/GID and automatically writes them to `.env`:
     ```bash
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
     ```
