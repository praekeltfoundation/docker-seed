#!/usr/bin/env bash
# Very rudimentary tests to make sure stage-based-messaging can start

source ../test-common.sh

# Start RabbitMQ and PostgreSQL first
start_and_wait_for_infrastructure

# Start up everything else
docker-compose up -d

# Django tests
# ============
wait_for_gunicorn_start message-sender

# Check that the Django admin page is accessible
curl -sfL "$(get_service_local_address message-sender)"/admin | fgrep '<title>Log in | Django site admin</title>'

# Check the database tables were created
[[ $(psql_cmd -q --dbname message-sender -c \
  "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';" \
    | grep -E '^\s*[[:digit:]]+' | tr -d ' ') > 0 ]]

# Celery tests
# ============
wait_for_celery_worker_start message-sender-celery
wait_for_celery_worker_start message-sender-celery-metrics
wait_for_celery_worker_start message-sender-celery-send

QUEUES="$(rabbitmqctl_cmd list_queues -p message-sender)"

echo "$QUEUES" | grep -E '^seed_message_sender\s'
echo "$QUEUES" | grep -E '^priority\s'
echo "$QUEUES" | grep -E '^mediumpriority\s'
echo "$QUEUES" | grep -E '^celery\s'

echo "$QUEUES" | grep -E '^metrics\s'

echo "$QUEUES" | grep -E '^lowpriority\s'

set +x
echo
echo "PASSED"
