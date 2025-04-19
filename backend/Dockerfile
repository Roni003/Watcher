# syntax=docker/dockerfile:1

ARG NODE_VERSION=20.10.0

FROM node:${NODE_VERSION}-alpine as base

WORKDIR /usr/src/app

FROM base as deps

COPY package*.json ./

RUN --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev

FROM deps as build

RUN --mount=type=cache,target=/root/.npm \
    npm ci

COPY . .

RUN npm run build

FROM base as final

ENV NODE_ENV=production

USER node

COPY package.json ./

COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/build ./build

EXPOSE 3000

CMD npm run start