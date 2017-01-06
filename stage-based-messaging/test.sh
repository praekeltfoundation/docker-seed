#!/usr/bin/env bash
set -e

# Very rudimentary tests to make sure stage-based-messaging can start

# Make sure we shut down everything on exit
trap "docker-compose down" EXIT
# Make sure it's clear when something has failed
trap '{ set +x; echo; echo FAILED; echo; } >&2' ERR

# Tests start
set -x

# Start infrastructure first
# FIXME: We have to start postgres first or else the Django app fails to start
docker-compose up -d seed-postgres seed-rabbitmq
sleep 5

# Start up everything else
docker-compose up -d
sleep 5

# Check we have 5 containers
# Trim leading whitespace for macOS wc compatibility
[[ "$(docker-compose ps -q | wc -l | tr -d ' ')" = 5 ]]

# Check that the Django admin page is accessible
curl -sIfL localhost:8000/admin

# Check that the Celery worker queues are created
rabbitmq_queue_exists() {
  local name="$1"; shift
  curl -If -u stage-based-messaging:secret "localhost:15672/api/queues/stage-based-messaging/$name"
}

rabbitmq_queue_exists seed_stage_based_messaging

rabbitmq_queue_exists priority
rabbitmq_queue_exists mediumpriority
rabbitmq_queue_exists metrics
rabbitmq_queue_exists celery
