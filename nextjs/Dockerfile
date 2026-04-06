# Multi-stage Dockerfile for Next.js (standard runtime)

FROM node:20-alpine AS base

# Install system deps needed by some npm packages
RUN apk add --no-cache libc6-compat

WORKDIR /app

# -----------------------------
# Dependencies layer
FROM base AS deps
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund

# -----------------------------
# Builder layer
FROM base AS builder
ENV NEXT_TELEMETRY_DISABLED=1 \
    NODE_ENV=production
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build Next.js (standard build without standalone)
RUN npm run build

# -----------------------------
# Runner layer
FROM node:20-alpine AS runner

ARG APP_RESPONSE="Built with Dockerfile"
ENV NODE_ENV=production \
    PORT=3000 \
    HOSTNAME=0.0.0.0 \
    APP_RESPONSE=${APP_RESPONSE}

WORKDIR /app

# Non-root runtime
USER node

# Copy the built application (standard Next.js build)
COPY --from=builder --chown=node:node /app/public ./public
COPY --from=builder --chown=node:node /app/.next ./.next
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/package.json ./package.json

EXPOSE 3000

# Start with npm run start for consistency with Nixpacks
CMD ["npm", "start"]


