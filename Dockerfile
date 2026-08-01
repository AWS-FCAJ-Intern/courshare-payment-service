# Stage 1: Build the application
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma/
RUN npm ci

COPY tsconfig.json ./
COPY src ./src/
RUN npx prisma generate
RUN npm run build

# Stage 2: Production runtime image
FROM node:20-alpine
WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

# Copy generated Prisma Client from build stage to avoid downloading CLI at runtime
COPY --from=build /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=build /app/node_modules/@prisma/client ./node_modules/@prisma/client

COPY --from=build /app/dist ./dist
COPY certs/ /app/certs/
EXPOSE 8083
CMD ["node", "dist/index.js"]
