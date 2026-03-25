# Lightweight Node.js image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy dependencies first
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy app code
COPY . .

# Expose port
EXPOSE 8080

# Start app
CMD ["node", "main.js"]