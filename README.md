# Medusa Backend Docker Build

This repository contains a GitHub Actions workflow that automatically builds and pushes Docker images of the Medusa backend server.

## Features

- Automatically pulls the latest Medusa source code from the official repository
- Builds multi-platform Docker images (linux/amd64, linux/arm64)
- Supports manual workflow dispatch with custom Medusa versions
- Uses Docker layer caching for faster builds
- Pushes images to Docker Hub with proper tagging

## Setup

### 1. Repository Secrets

Add the following secrets to your GitHub repository:

- `DOCKER_USERNAME`: Your Docker Hub username
- `DOCKER_PASSWORD`: Your Docker Hub password or access token

### 2. Workflow Triggers

The workflow will automatically run on:
- Push to `main` or `master` branch
- Pull requests to `main` or `master` branch
- Manual workflow dispatch (with optional version specification)

### 3. Manual Build

To manually trigger a build with a specific Medusa version:

1. Go to the "Actions" tab in your repository
2. Select "Build and Push Docker Image"
3. Click "Run workflow"
4. Optionally specify a Medusa version (e.g., `v1.12.0`)
5. Click "Run workflow"

## Docker Image

The built image will be available at:
```
your-docker-username/medusa-backend:latest
```

### Running the Container

```bash
docker run -p 9000:9000 your-docker-username/medusa-backend:latest
```

### Environment Variables

The container expects the following environment variables:
- `DATABASE_URL`: PostgreSQL connection string
- `REDIS_URL`: Redis connection string
- `JWT_SECRET`: JWT secret for authentication
- `COOKIE_SECRET`: Secret for cookie encryption

Example:
```bash
docker run -p 9000:9000 \
  -e DATABASE_URL=postgres://user:pass@host:5432/medusa \
  -e REDIS_URL=redis://host:6379 \
  -e JWT_SECRET=your-jwt-secret \
  -e COOKIE_SECRET=your-cookie-secret \
  your-docker-username/medusa-backend:latest
```

## Build Process

1. **Clone Medusa Repository**: Downloads the latest Medusa source code
2. **Extract Backend**: Copies the backend package files to the build context
3. **Multi-stage Build**: 
   - Installs dependencies
   - Builds the application
   - Creates optimized production image
4. **Push to Registry**: Pushes the built image to Docker Hub

## Tags

The workflow automatically creates tags based on:
- Branch name (e.g., `main`)
- Git SHA (e.g., `main-abc123`)
- Semantic versioning (if using tags)

## Contributing

Feel free to submit issues and enhancement requests!
