FROM node:24-alpine

ARG NODE_USER_UID=1000
ARG NODE_USER_GID=1000

# Reconfigure node user UID/GID if different from default (1000:1000)
RUN if [ "$NODE_USER_UID" != "1000" ] || [ "$NODE_USER_GID" != "1000" ]; then \
        deluser --remove-home node && \
        addgroup -g "$NODE_USER_GID" node && \
        adduser -m -u "$NODE_USER_UID" -G node -s /bin/sh -D node; \
    fi

WORKDIR /app

# Install 9router globally
RUN npm install -g 9router

EXPOSE 20128

USER node

# --tray runs in daemon mode
# --skip-update skips update prompts
CMD ["9router", "--tray", "--skip-update"]
