#!/usr/bin/env bash
# Very rudimentary tests to make sure stage-based-messaging can start

source ../test-common.sh

# Start RabbitMQ and PostgreSQL first
start_and_wait_for_infrastructure

# Django tests
# ============
# FIXME: Need to bring up main service first to create DBs for Celery beat
docker-compose up -d scheduler

wait_for_gunicorn_start scheduler

# Check that the Django admin page is accessible
curl -sfL "$(get_service_local_address scheduler)"/admin | fgrep '<title>Log in | Django site admin</title>'

# Check the database tables were created
[[ $(psql_cmd -q --dbname scheduler -c \
  "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';" \
    | grep -E '^\s*[[:digit:]]+' | tr -d ' ') > 0 ]]

# Celery tests
# ============
# Start up everything else
docker-compose up -d

wait_for_celery_beat_start scheduler-celery-beat

wait_for_celery_worker_start scheduler-celery
wait_for_celery_worker_start scheduler-celery-metrics
wait_for_celery_worker_start scheduler-celery-send

QUEUES="$(rabbitmqctl_cmd list_queues -p scheduler)"

echo "$QUEUES" | grep -E '^seed_scheduler\s'
echo "$QUEUES" | grep -E '^priority\s'
echo "$QUEUES" | grep -E '^mediumpriority\s'
echo "$QUEUES" | grep -E '^celery\s'

echo "$QUEUES" | grep -E '^metrics\s'

echo "$QUEUES" | grep -E '^lowpriority\s'

set +x
echo
echo "PASSED"
