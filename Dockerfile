# Use specific version for security
FROM node:18-slim

# Create app directory and set ownership
WORKDIR /usr/src/app

# Install dependencies first (better caching)
COPY package*.json ./
RUN npm install --production && \
    # Remove npm cache
    npm cache clean --force && \
    # Create non-root user
    groupadd -r appuser && \
    useradd -r -g appuser -s /bin/false appuser && \
    # Set permissions
    chown -R appuser:appuser .

# Copy app source with correct permissions
COPY --chown=appuser:appuser . .

# Use non-root user
USER appuser

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/health || exit 1

CMD [ "node", "server.js" ] 