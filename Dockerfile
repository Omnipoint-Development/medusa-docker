# Use Node.js 22 Alpine as base image
FROM node:22-alpine AS base

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /server

# Install dependencies based on the preferred package manager
COPY package.json ./
COPY package-lock.json* ./
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /server
COPY --from=deps /server/node_modules ./node_modules
COPY . .

# Build the application
RUN npm run build

# Production image, copy all the files and run the app
FROM base AS runner
WORKDIR /server

ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 medusa

# Copy built application
COPY --from=builder /server/dist ./dist
COPY --from=builder /server/node_modules ./node_modules
COPY --from=builder /server/package.json ./package.json
COPY --from=builder /server/start.sh ./start.sh

# Make start.sh executable
RUN chmod +x start.sh

USER medusa

EXPOSE 9000

ENV PORT=9000
ENV HOSTNAME="0.0.0.0"

CMD ["./start.sh"]
