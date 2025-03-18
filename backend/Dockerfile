# syntax=docker/dockerfile:1

ARG NODE_VERSION=20.10.0

################################################################################
# Use node image for base image for all stages.
FROM node:${NODE_VERSION}-alpine as base

# Set working directory for all stages
WORKDIR /usr/src/app

################################################################################
# Create a stage for installing production dependencies.
FROM base as deps

# Copy package files from the current directory (backend)
COPY package*.json ./

# Install dependencies using the copied package files
RUN --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev

################################################################################
# Create a stage for building the application.
FROM deps as build

# Install all dependencies for build
RUN --mount=type=cache,target=/root/.npm \
    npm ci

# Copy the backend source code
COPY . .

# Run the build script
RUN npm run build

################################################################################
# Create a new stage to run the application with minimal runtime dependencies
FROM base as final

# Use production node environment by default.
ENV NODE_ENV=production

# Run the application as a non-root user.
USER node

# Copy package.json
COPY package.json ./

# Copy the production dependencies and built application
COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/build ./build

# Expose the port that the application listens on.
EXPOSE 3000

# Run the application.
CMD npm run start