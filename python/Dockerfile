# -----------------------------------
# Python requirements stage
FROM python:3.12.11-alpine3.21 AS python
FROM python AS build 

RUN apk add --no-cache \
    alpine-sdk rust cargo libffi-dev openssl-dev libpq-dev build-base && \
    mkdir -p /opt/app-requirements

RUN pip install --no-cache-dir poetry==2.1.4

WORKDIR /opt/app-requirements

COPY app.py pyproject.toml poetry.lock ./
COPY py_app/. py_app/
COPY static/. static/

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

RUN set -eux; \
    poetry install --without=dev --with=build --no-root; \
    poetry run pyinstaller \
    --add-data static/favicon.png:static \
    --optimize=1 \
    --strip \
    --name app app.py; \
    rm -rf $POETRY_CACHE_DIR

# -----------------------------------
# Install built sources and run
FROM alpine:3.21

ARG APP_USER=so
ARG APP_HOME=home
ARG APP_RESPONSE="Built with Dockerfile"
ARG API_PORT=8080
ARG DEBUG_MODE

RUN set -eux; \
    adduser -D --home /${APP_HOME}/${APP_USER}/ ${APP_USER}

USER ${APP_USER}

WORKDIR /${APP_HOME}/${APP_USER}

COPY --from=build --chown=${APP_USER}:${APP_USER} /opt/app-requirements/dist/app ./app/

ENV APP_RESPONSE=${APP_RESPONSE} \
    APP_API_PORT=${API_PORT} \
    DEBUG=${DEBUG_MODE}

EXPOSE ${APP_API_PORT}

WORKDIR /${APP_HOME}/${APP_USER}/app

# Shell mode to use APP_RESPONSE
ENTRYPOINT ./app $(echo ${APP_RESPONSE})
