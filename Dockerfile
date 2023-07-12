ARG APP=puppeteerapp

# Base using latest NPM
FROM node:16-buster-slim AS base

# We don't need the standalone Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install Google Chrome Stable and fonts
# Note: this installs the necessary libs to make the browser work with Puppeteer.
RUN apt-get update && apt-get install gnupg wget -y && \
  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install google-chrome-stable -y --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

  
WORKDIR /puppeteerapp
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
COPY package.json package-lock.json /puppeteerapp/
RUN \
  npm ci --only=production --omit=dev

# Build
FROM base AS build
COPY package.json package-lock.json tsconfig.json /puppeteerapp/
COPY ./src /puppeteerapp/src
RUN \
  npm install && \
  npm run build
# COPY credentials.json /app/dist/

# Release
FROM public.ecr.aws/lambda/nodejs:14
ARG APP
COPY --from=deps /puppeteerapp/node_modules "${LAMBDA_TASK_ROOT}/node_modules"
COPY --from=build /puppeteerapp/dist/ "${LAMBDA_TASK_ROOT}/"
# RUN cp "${LAMBDA_TASK_ROOT}/${APP}.js" "${LAMBDA_TASK_ROOT}/app.js"
CMD ["app.handler"]