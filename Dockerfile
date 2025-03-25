# Use Node.js LTS version
FROM node:18-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm ci --only=production

# Bundle app source
COPY . .

# Use non-root user for security
USER node

# Expose port
EXPOSE 3000

CMD [ "node", "server.js" ] 