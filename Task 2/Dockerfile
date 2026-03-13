# --- Stage 1: Install Dependencies ---
FROM node:20-alpine AS deps
WORKDIR /app
# Kita cuma copy package.json dulu untuk install dependency
COPY app/package.json ./
RUN npm install

# --- Stage 2: Build the Application ---
FROM node:20-alpine AS builder
WORKDIR /app
# Copy semua source code aplikasi
COPY app/ ./
# Copy node_modules dari tahap deps sebelumnya
COPY --from=deps /app/node_modules ./node_modules
# Build Next.js
RUN npm run build

# --- Stage 3: Production Runner ---
FROM node:20-alpine AS runner
WORKDIR /app

# Set environment ke production biar lebih ngebut
ENV NODE_ENV production

# RUN addgroup --system --gid 1001 nodejs
# RUN adduser --system --uid 1001 nextjs

# RUN mkdir .next
# RUN chown nextjs:nodejs .next
# Copy file hasil build dan dependencies yang diperlukan saja
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
# COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose port sesuai permintaan soal
EXPOSE 3000

# Command untuk menjalankan aplikasi
CMD ["node", "server.js"]