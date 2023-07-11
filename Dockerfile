ARG APP=holidayapp

# Base using latest NPM
FROM node:16-buster-slim AS base
WORKDIR /app
RUN \
  mv \
    /usr/local/lib/node_modules \
    /usr/local/lib/node_modules.tmp && \
  mv \
    /usr/local/lib/node_modules.tmp \
    /usr/local/lib/node_modules && \
    npm i -g npm@latest

# Dependencies
FROM base AS deps
ARG NODE_ENV=production
COPY package.json package-lock.json /app/
RUN \
  npm ci --only=production

# Build
FROM base AS build
COPY package.json package-lock.json tsconfig.json /app/
COPY ./src /app/src
RUN \
  npm install && \
  npm run build
COPY credentials.json /app/dist/

# Release
FROM public.ecr.aws/lambda/nodejs:14
ARG APP
COPY --from=deps /app/node_modules "${LAMBDA_TASK_ROOT}/node_modules"
COPY --from=build /app/dist/ "${LAMBDA_TASK_ROOT}/"
RUN cp "${LAMBDA_TASK_ROOT}/${APP}.js" "${LAMBDA_TASK_ROOT}/app.js"
CMD ["app.handler"]