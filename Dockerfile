# STAGE 1: Builder
FROM oven/bun:latest AS builder
WORKDIR /app

# 1. Build the Web Frontend
COPY web/package.json web/bun.lock* ./web/
RUN cd web && bun install --frozen-lockfile
COPY web/ ./web/

# Pass build arguments for Vite
ARG VITE_CLERK_PUBLISHABLE_KEY
ARG VITE_API_URL
ENV VITE_CLERK_PUBLISHABLE_KEY=$VITE_CLERK_PUBLISHABLE_KEY
ENV VITE_API_URL=$VITE_API_URL

RUN cd web && bun run build

# 2. Install Backend Dependencies
COPY backend/package.json backend/bun.lock* ./backend/
RUN cd backend && bun install --frozen-lockfile
COPY backend/ ./backend/

# STAGE 2: Runner (Production)
FROM oven/bun:latest
WORKDIR /app

# Copy only the built web files and backend source
COPY --from=builder /app/web/dist ./web/dist
COPY --from=builder /app/backend ./backend

WORKDIR /app/backend

# Expose and Runtime Envs
EXPOSE 3000
ENV PORT=3000
ENV NODE_ENV=production

# Start the app using the backend entry point
CMD ["bun", "run", "index.ts"]