# syntax=docker/dockerfile:1
FROM oven/bun:1.1-distroless AS base

FROM base AS deps
WORKDIR /app
COPY package.json bun.lockb ./
RUN bun install --production --frozen-lockfile

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN bun run --bun build

FROM base AS runner
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.4 /lambda-adapter /opt/extensions/lambda-adapter
ENV PORT=3000 NODE_ENV=production
# Enable compression
ENV AWS_LWA_ENABLE_COMPRESSION=true
WORKDIR /app
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

COPY --from=builder /app/run.sh ./run.sh
RUN chmod +x ./run.sh && ln -s /tmp/cache ./.next/cache

CMD ["./run.sh"]
