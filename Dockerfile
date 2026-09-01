FROM node:24-alpine

WORKDIR /app

# Install 9router globally
RUN npm install -g 9router

EXPOSE 20128

USER node

# --tray runs in daemon mode
# --skip-update skips update prompts
CMD ["9router", "--tray", "--skip-update"]
