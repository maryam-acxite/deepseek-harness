FROM node:22-bookworm-slim AS builder

WORKDIR /app

# Install native dependencies and pnpm
RUN apt-get update && apt-get install -y git python3 make g++ && rm -rf /var/lib/apt/lists/*
RUN npm install -g pnpm@9

# Copy project files
COPY . .

# Install dependencies and build web & core packages
RUN pnpm install --no-frozen-lockfile
RUN pnpm run build

# --- Runtime Stage ---
FROM node:22-bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git curl python3 && rm -rf /var/lib/apt/lists/*
RUN npm install -g pnpm@9

COPY --from=builder /app /app

ENV HOST=0.0.0.0
ENV PORT=3080

EXPOSE 3080

CMD ["pnpm", "dsh", "web", "--host", "0.0.0.0", "--port", "3080", "--no-open"]
