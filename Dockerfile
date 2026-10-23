# Build da aplicação a partir do ZIP versionado no repositório.
# O ZIP contém backend/ e web/ sob a pasta automate-clipping-main/.
FROM node:20-alpine AS web-build
RUN apk add --no-cache unzip
WORKDIR /src
COPY automate-clipping-main-configured.zip /tmp/edgetape.zip
RUN unzip -q /tmp/edgetape.zip -d /src \
    && test -f /src/automate-clipping-main/web/package.json \
    && test -f /src/automate-clipping-main/backend/requirements.txt
RUN corepack enable && corepack prepare pnpm@9.15.4 --activate
WORKDIR /src/automate-clipping-main/web
RUN pnpm install --frozen-lockfile
RUN pnpm build

FROM python:3.12-slim AS runtime
RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg unzip \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY automate-clipping-main-configured.zip /tmp/edgetape.zip
RUN unzip -q /tmp/edgetape.zip -d /src \
    && test -f /src/automate-clipping-main/backend/app/main.py \
    && test -f /src/automate-clipping-main/backend/app/autopilot.py
WORKDIR /app
COPY --from=web-build /src/automate-clipping-main/backend/requirements.txt ./backend/requirements.txt
RUN pip install --no-cache-dir -r backend/requirements.txt
COPY --from=web-build /src/automate-clipping-main/backend/ ./backend/
COPY --from=web-build /src/automate-clipping-main/web/ ./web/
COPY --from=web-build /src/automate-clipping-main/web/dist/ ./web/dist/
COPY --from=web-build /src/automate-clipping-main/backend/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /app/backend
ENV EDGETAPE_ROLE=all
EXPOSE 8000
CMD ["/entrypoint.sh"]
