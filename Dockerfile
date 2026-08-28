FROM node:22-bookworm-slim

WORKDIR /app

# Install native dependencies + socat for port proxying
RUN apt-get update && apt-get install -y git curl python3 build-essential socat && rm -rf /var/lib/apt/lists/*

RUN npm install -g @deepseek-ai/dsh

EXPOSE 3080

# Clean .env, bind dsh to 127.0.0.1, and forward container traffic from 0.0.0.0:3080 to localhost
CMD ["sh", "-c", "rm -f /app/.env && socat TCP-LISTEN:3080,fork,reuseaddr TCP:127.0.0.1:3081 & dsh web --port 3081 --no-open"]
