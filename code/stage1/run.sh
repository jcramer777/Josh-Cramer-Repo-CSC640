#!/bin/bash
# Start the Stage 1 services (MySQL, PHP-FPM, NGINX) and check that the API answers.
# First time on a machine? Run setup.sh instead.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

start_service() { sudo service "$1" start >/dev/null 2>&1 || sudo systemctl start "$1" || true; }
start_service mysql
FPM_SERVICE="$(ls /etc/init.d 2>/dev/null | grep -E '^php[0-9.]+-fpm$' | head -1 || true)"
[ -n "$FPM_SERVICE" ] && start_service "$FPM_SERVICE"
start_service nginx

sleep 1
if curl -sf http://localhost:8080/api >/dev/null; then
  echo "Stage 1 API is up: http://localhost:8080/api"
  echo "Run the tests:     STAGE=stage1 bash $HERE/../tests/run_tests.sh"
else
  echo "API did not answer on http://localhost:8080/api. Run setup.sh first, then check: sudo tail /var/log/nginx/error.log" >&2
  exit 1
fi
