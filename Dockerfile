FROM node:24-slim

ARG NODE_USER_UID=1000
ARG NODE_USER_GID=1000

# Reconfigure node user UID/GID if different from default (1000:1000)
RUN if [ "$NODE_USER_UID" != "1000" ] || [ "$NODE_USER_GID" != "1000" ]; then \
        groupmod -g "$NODE_USER_GID" node && \
        usermod -u "$NODE_USER_UID" -g "$NODE_USER_GID" node && \
        chown -R "$NODE_USER_UID":"$NODE_USER_GID" /home/node; \
    fi

WORKDIR /app

# Install 9router globally
RUN npm install -g 9router

EXPOSE 20128

USER node

# --tray runs in daemon mode
# --skip-update skips update prompts
CMD ["9router", "--tray", "--skip-update"]
