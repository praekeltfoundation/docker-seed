#!/usr/bin/env bash
# Very rudimentary tests to make sure stage-based-messaging can start

source ../test-common.sh

# Start RabbitMQ and PostgreSQL first
start_and_wait_for_infrastructure

# Start up everything else
docker-compose up -d

# Django tests
# ============
wait_for_gunicorn_start stage-based-messaging

# Check that the Django admin page is accessible
curl -sfL "$(get_service_local_address stage-based-messaging)"/admin | fgrep '<title>Log in | Django site admin</title>'

# Check the database tables were created
[[ $(psql_cmd -q --dbname stage-based-messaging -c \
  "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';" \
    | grep -E '^\s*[[:digit:]]+' | tr -d ' ') > 0 ]]

# Celery tests
# ============
wait_for_celery_worker_start stage-based-messaging-celery
wait_for_celery_worker_start stage-based-messaging-celery-metrics

QUEUES="$(rabbitmqctl_cmd list_queues -p stage-based-messaging)"

echo "$QUEUES" | grep -E '^seed_stage_based_messaging\t'

echo "$QUEUES" | grep -E '^priority\t'
echo "$QUEUES" | grep -E '^mediumpriority\t'
echo "$QUEUES" | grep -E '^metrics\t'
echo "$QUEUES" | grep -E '^celery\t'

set +x
echo
echo "PASSED"
