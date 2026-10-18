#!/bin/bash
# Stage 1 setup: MySQL database + user, schema + seed data, NGINX site for the PHP API.
# Targets Ubuntu / WSL2 (as in the ASE 230 course). Run once:  bash setup.sh
# Needs: nginx, php-fpm, php-mysql, mysql-server  (see ase230 course_tools/ for installers).
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
API_DIR="$HERE/api"
DB_NAME="${DB_NAME:-todo_api}"
DB_USER="${DB_USER:-todo_user}"
DB_PASS="${DB_PASSWORD:-todo_pass}"      # local development credentials only

for tool in php nginx mysql; do
  command -v "$tool" >/dev/null || { echo "Missing required tool: $tool" >&2; exit 1; }
done

# --- services ---------------------------------------------------------------
start_service() { sudo service "$1" start >/dev/null 2>&1 || sudo systemctl start "$1" || true; }
start_service mysql
FPM_SERVICE="$(ls /etc/init.d 2>/dev/null | grep -E '^php[0-9.]+-fpm$' | head -1 || true)"
[ -n "$FPM_SERVICE" ] && start_service "$FPM_SERVICE"

# --- database ---------------------------------------------------------------
sudo mysql <<SQL
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
SQL
MYSQL_PWD="$DB_PASS" mysql -u "$DB_USER" "$DB_NAME" < "$API_DIR/schema.sql"
MYSQL_PWD="$DB_PASS" mysql -u "$DB_USER" "$DB_NAME" < "$API_DIR/seed.sql"

# --- NGINX ------------------------------------------------------------------
FPM_SOCK="$(ls /run/php/php*-fpm.sock 2>/dev/null | head -1 || true)"
[ -n "$FPM_SOCK" ] || { echo "PHP-FPM socket not found in /run/php/ (is php-fpm running?)" >&2; exit 1; }

sed -e "s|__API_ROOT__|$API_DIR|" -e "s|__FPM_SOCK__|$FPM_SOCK|" \
    "$HERE/nginx/todo-api.conf.template" | sudo tee /etc/nginx/sites-available/todo-api >/dev/null
sudo ln -sf /etc/nginx/sites-available/todo-api /etc/nginx/sites-enabled/todo-api
sudo nginx -t
sudo service nginx reload >/dev/null 2>&1 || sudo systemctl reload nginx || sudo service nginx start

echo
echo "Stage 1 is ready:  http://localhost:8080/api"
echo "Test page:         http://localhost:8080/test.html"
echo "Run the tests:     bash $HERE/../tests/run_tests.sh"
echo "(NGINX may need read access to $API_DIR; if you see 403/404, move the project under your home folder with o+x permissions.)"
