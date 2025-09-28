# Stage 1: Build
FROM node:22-alpine AS builder

WORKDIR /app

COPY app/package.json ./
COPY app ./
RUN npm install && npm run build

# Stage 2: Production Image
FROM node:22-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Install only production dependencies
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules


EXPOSE 3000

CMD ["npm", "start"]

