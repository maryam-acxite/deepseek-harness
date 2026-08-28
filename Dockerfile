FROM node:22-bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git curl python3 build-essential && rm -rf /var/lib/apt/lists/*
RUN npm install -g @deepseek-ai/dsh

ENV HOST=0.0.0.0
ENV PORT=3080

EXPOSE 3080

CMD ["sh", "-c", "rm -f /app/.env && dsh web --host 0.0.0.0 --port 3080 --no-open"]
