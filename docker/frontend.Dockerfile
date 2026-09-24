FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY frontend/package*.json ./

# Install the exact dependency versions recorded in the lockfile.
RUN npm ci

# Copy source code
COPY frontend/ ./

# Expose port
EXPOSE 5173

# Start development server
CMD ["npm", "run", "dev"]
