# docker-9router

Docker containerization for [9router](https://www.npmjs.com/package/9router), providing an easy-to-deploy routing and reverse proxy management service.

## 🚀 Features

- **Lightweight**: Based on Node 24 Alpine.
- **Persistent Storage**: Configuration and data stored in `./data` (`/home/node/.9router`).
- **Configurable**: Easily configure ports and initial setup via `.env`.
- **Non-root Execution**: Runs as non-root `node` user inside the container for better security.

---

## 📋 Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/)

---

## ⚡ Quick Start

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd docker-9router
   ```

2. **Configure environment variables:**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` according to your preferences:
   ```dotenv
   # Port to expose (default: 20128)
   PORT=20128

   # Initial setup password (optional)
   INITIAL_PASSWORD=your_secure_password
   ```

3. **Start the service:**
   ```bash
   docker compose up -d --build
   ```

4. **Access the dashboard:**
   Open your browser and navigate to:
   ```text
   http://localhost:20128
   ```
   *(or the custom port you configured in `.env`)*

---

## ⚙️ Configuration

The following environment variables can be configured in your `.env` file:

| Variable | Description | Default |
| :--- | :--- | :--- |
| `PORT` | Host port mapped to the 9router service | `20128` |
| `INITIAL_PASSWORD` | Pre-configured admin password for initial setup | *(empty)* |
| `JWT_SECRET` | Secret key for JWT authentication (optional) | *(empty)* |

---

## 📂 Project Structure

```text
docker-9router/
├── .env.example       # Example environment variables
├── .gitignore         # Git ignore configuration
├── docker-compose.yml # Docker Compose specification
├── Dockerfile         # Container build recipe
├── LICENSE            # MIT License
├── README.md          # Project documentation
└── data/              # Persistent data volume for 9router
```

---

## 🛠️ Useful Commands

- **View logs:**
  ```bash
  docker compose logs -f
  ```

- **Restart service:**
  ```bash
  docker compose restart
  ```

- **Stop service:**
  ```bash
  docker compose down
  ```

- **Update container image:**
  ```bash
  docker compose build --no-cache
  docker compose up -d
  ```

---

Copyright © 2026 ryumada. All Rights Reserved.

Licensed under the [MIT](LICENSE) license.
