#!/usr/bin/env bash
# NFX-Stack launcher
# Reads root .env + Infrastructure/docker-compose.*.yml (skips *.example.*)
#
# Usage:
#   ./start.sh          # up -d
#   ./start.sh up       # up -d
#   ./start.sh down     # stop & remove
#   ./start.sh ps       # status
#   ./start.sh logs     # recent logs
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${ROOT}/.env"
INFRA_DIR="${ROOT}/Infrastructure"
ACTION="${1:-up}"
DOCKER="${DOCKER:-sudo docker}"

PREFERRED_ORDER=(
  docker-compose.mysql.yml
  docker-compose.mongodb.yml
  docker-compose.postgresql.yml
  docker-compose.redis.yml
  docker-compose.kafka.yml
  docker-compose.rabbitmq.yml
  docker-compose.minio.yml
  docker-compose.centrifugo.yml
  docker-compose.otel.yml
  docker-compose.opensearch.yml
)

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "missing env file: ${ENV_FILE}" >&2
  echo "copy .example.env to .env and fill in values" >&2
  exit 1
fi

if [[ ! -d "${INFRA_DIR}" ]]; then
  echo "missing infrastructure dir: ${INFRA_DIR}" >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is not installed or not in PATH" >&2
  exit 1
fi

compose_files=()
for name in "${PREFERRED_ORDER[@]}"; do
  file="${INFRA_DIR}/${name}"
  if [[ -f "${file}" ]]; then
    compose_files+=("${file}")
  fi
done

shopt -s nullglob
for file in "${INFRA_DIR}"/docker-compose.*.yml; do
  base="$(basename "${file}")"
  case "${base}" in
    docker-compose.example.*) continue ;;
  esac
  already=0
  for existing in "${compose_files[@]}"; do
    if [[ "${existing}" == "${file}" ]]; then
      already=1
      break
    fi
  done
  if [[ "${already}" -eq 0 ]]; then
    compose_files+=("${file}")
  fi
done
shopt -u nullglob

if [[ ${#compose_files[@]} -eq 0 ]]; then
  echo "no infrastructure compose files found in ${INFRA_DIR}" >&2
  exit 1
fi

as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

# sudo docker 创建的 bind 目录常是 root:root 755；镜像内非 root 用户写不进去会 Restarting。
env_path() {
  local key="$1" default_path="$2" value
  value="$(awk -F= -v key="${key}" '$1==key{v=$2} END{print v}' "${ENV_FILE}")"
  printf '%s\n' "${value:-${default_path}}"
}

ensure_bind_dir() {
  local label="$1" uid="$2" gid="$3" path="$4"
  echo "ensuring ${label} data dir ${uid}:${gid}: ${path}"
  as_root mkdir -p "${path}"
  as_root chown -R "${uid}:${gid}" "${path}"
}

ensure_data_dirs() {
  # Grafana 472 / Prometheus nobody 65534 / Loki 10001 / OpenSearch 1000
  ensure_bind_dir Grafana 472 472 "$(env_path GRAFANA_DATA_PATH "${ROOT}/Databases/grafana")"
  ensure_bind_dir Prometheus 65534 65534 "$(env_path PROMETHEUS_DATA_PATH "${ROOT}/Databases/prometheus")"
  ensure_bind_dir Loki 10001 10001 "$(env_path LOKI_DATA_PATH "${ROOT}/Databases/loki")"
  ensure_bind_dir OpenSearch 1000 1000 "$(env_path OPENSEARCH_DATA_PATH "${ROOT}/Databases/opensearch")"
}

ensure_network() {
  if ! ${DOCKER} network inspect nfx-stack >/dev/null 2>&1; then
    echo "creating docker network: nfx-stack"
    ${DOCKER} network create nfx-stack >/dev/null
  fi
}

run_compose() {
  local file="$1"
  shift
  echo "==> $(basename "${file}") $*"
  ${DOCKER} compose \
    --project-directory "${INFRA_DIR}" \
    --env-file "${ENV_FILE}" \
    -f "${file}" \
    "$@"
}

case "${ACTION}" in
  up|start)
    ensure_network
    ensure_data_dirs
    for file in "${compose_files[@]}"; do
      run_compose "${file}" up -d
    done
    echo "infrastructure started (${#compose_files[@]} stacks)"
    ;;
  down|stop)
    for ((i = ${#compose_files[@]} - 1; i >= 0; i--)); do
      run_compose "${compose_files[$i]}" down
    done
    echo "infrastructure stopped"
    ;;
  ps|status)
    for file in "${compose_files[@]}"; do
      run_compose "${file}" ps
    done
    ;;
  logs)
    for file in "${compose_files[@]}"; do
      run_compose "${file}" logs --tail=50
    done
    ;;
  *)
    echo "usage: $0 [up|down|ps|logs]" >&2
    exit 1
    ;;
esac
