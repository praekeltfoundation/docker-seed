# Common Bash functions and options to be used in all tests. This script should be sources.

# Fail on errors and intermediate piped commands
set -eo pipefail

# Set some traps when the script exits

# Shut down containers on exit
trap "{ set +x; docker-compose down; }" EXIT

# Say when something has gone wrong
trap '{ set +x; echo; echo FAILED; echo; } >&2' ERR

# macOS-compatible timeout function: http://stackoverflow.com/a/35512328
function timeout() { perl -e 'alarm shift; exec @ARGV' "$@"; }

function wait_for_log_line() {
  local service="$1"; shift
  local log_pattern="$1"; shift
  local log_timeout="${1:-10}"
  timeout "$log_timeout" grep -m 1 -E "$log_pattern" <(docker-compose logs -f "$service" 2>&1)
}

function check_service_up() {
  local service="$1"; shift
  docker-compose ps "$service" | fgrep 'Up'
}

function start_and_wait_for_infrastructure() {
  local db_service="${1:-postgres}"
  local amqp_service="${2:-rabbitmq}"

  docker-compose up -d "$db_service" "$amqp_service"

  wait_for_log_line "$db_service" 'database system is ready to accept connections'
  wait_for_log_line "$amqp_service" 'Server startup complete'

  check_service_up "$db_service"
  check_service_up "$amqp_service"
}

function wait_for_gunicorn_start() {
  local gunicorn_service="$1"; shift
  wait_for_log_line "$gunicorn_service" 'Booting worker'
  check_service_up "$gunicorn_service"
}

function wait_for_celery_worker_start() {
  local worker_service="$1"; shift
  wait_for_log_line "$worker_service" 'celery@\w+ ready'
  check_service_up "$worker_service"
}

function wait_for_celery_beat_start() {
  local beat_service="$1"; shift
  wait_for_log_line "$beat_service" 'beat: Starting\.\.\.'
  check_service_up "$beat_service"
}

function get_service_local_address() {
  local service="$1"; shift
  local private_port="${1:-8000}"
  echo 'localhost:'"$(docker-compose port "$service" "$private_port" | cut -d':' -f2)"
}

# Assumes RabbitMQ service is named 'rabbitmq'
function rabbitmqctl_cmd() {
  docker-compose exec rabbitmq rabbitmqctl "$@"
}

# Assumes PostgreSQL service is named 'postgres'
function psql_cmd() {
  docker-compose exec --user postgres postgres psql "$@"
}

# Log each command unless "$DEBUG"
[ "$QUIET" ] || set -x
