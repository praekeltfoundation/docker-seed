#!/usr/bin/env bash
set -e

function usage() {
	echo "usage: $1 IMAGE_NAME [OPTIONS]"
	echo "   eg: $1 praekeltfoundation/seed-message-sender --no-beat"
}

IMAGE="$1"
shift || { usage "$0" >&2; exit 1; }

CELERY_BEAT="YES"
CELERY_WORKER="YES"
CELERY_WORKER_METRICS="YES"
CELERY_WORKER_SEND="YES"

while [[ $# > 0 ]]; do
  key="$1"; shift

  case "$key" in
    --no-beat)
      CELERY_BEAT="NO"
      ;;
    --no-worker)
      CELERY_WORKER="NO"
      ;;
    --no-worker-metrics)
      CELERY_WORKER_METRICS="NO"
      ;;
    --no-worker-send)
      CELERY_WORKER_SEND="NO"
      ;;
    *)
      # Unknown option
      echo "Unknown parameter: $key" 1>&2
      exit 1
      ;;
  esac
done

# Export all the variables needed by the docker-compose file
COMPONENT="${IMAGE##*/}"                       # praekeltfoundation/seed-message-sender -> seed-message-sender
CLASS_NAME="$(echo "$COMPONENT" | tr '-' '_')" # seed-message-sender -> seed_message_sender
SHORT_NAME="${PACKAGE#seed-}"                  # seed-message-sender -> message-sender
SHORT_CLASS_NAME="${CLASS_NAME#seed_}"         # seed_message_sender -> message_sender

export IMAGE="$IMAGE"
export BUILD_CONTEXT="${BUILD_CONTEXT:-$SHORT_NAME}"

export DATABASE_ENV="${DATABASE_ENV_NAME:-${SHORT_CLASS_NAME^^}_DATABASE}"

export CELERY_APP="${CELERY_APP:-$CLASS_NAME}"
export CELERY_QUEUE_APP="${CELERY_QUEUE_APP:-$CLASS_NAME}"

# Test time
source test-common.sh

# XXX: Everything is brought up in a strict order here. In the real world we may
# not be so lucky. How do we test things starting in different orders?

# Start RabbitMQ and PostgreSQL first
start_and_wait_for_infrastructure

# Django tests
# ============
docker-compose up -d django

wait_for_gunicorn_start django

# Check that the Django admin page is accessible
curl -sfL "$(get_service_local_address django)"/admin | fgrep '<title>Log in | Django site admin</title>'

# Check the database tables were created
[[ $(psql_cmd -q --dbname db -c \
  "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';" \
    | grep -E '^\s*[[:digit:]]+' | tr -d ' ') > 0 ]]


# Celery tests
# ============
if [[ "$CELERY_BEAT" = 'YES' ]]; then
  docker-compose up -d celery-beat
  wait_for_celery_beat_start celery-beat
  # FIXME: Anything more we can assert about Celery beat?
fi

if [[ "$CELERY_WORKER" = 'YES' ]]; then
  docker-compose up -d celery-worker
  wait_for_celery_worker_start celery-worker
  QUEUES="$(rabbitmqctl_cmd list_queues -p /vhost)"
  echo "$QUEUES" | grep -E "^$CELERY_QUEUE_APP\s"
  echo "$QUEUES" | grep -E '^priority\s'
  echo "$QUEUES" | grep -E '^mediumpriority\s'
  echo "$QUEUES" | grep -E '^celery\s'
fi

if [[ "$CELERY_WORKER_METRICS" = 'YES' ]]; then
  docker-compose up -d celery-worker-metrics
  wait_for_celery_worker_start celery-worker-metrics
  rabbitmqctl_cmd list_queues -p /vhost | grep -E '^metrics\s'
fi

if [[ "$CELERY_WORKER_SEND" = 'YES' ]]; then
  docker-compose up -d celery-worker-send
  wait_for_celery_worker_start celery-worker-send
  rabbitmqctl_cmd list_queues -p /vhost | grep -E '^lowpriority\s'
fi

set +x
echo
echo 'PASSED'
