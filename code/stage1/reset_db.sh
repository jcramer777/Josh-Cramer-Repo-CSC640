#!/bin/bash
# Reset Stage 1 data to the known seed state (drops and recreates all tables), so acceptance tests start clean.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_NAME="${DB_NAME:-todo_api}"
DB_USER="${DB_USER:-todo_user}"
DB_PASS="${DB_PASSWORD:-todo_pass}"

export MYSQL_PWD="$DB_PASS"
mysql -u "$DB_USER" "$DB_NAME" -e "SET FOREIGN_KEY_CHECKS=0; DROP TABLE IF EXISTS tasks, api_tokens, categories, users; SET FOREIGN_KEY_CHECKS=1;"
mysql -u "$DB_USER" "$DB_NAME" < "$HERE/api/schema.sql"
mysql -u "$DB_USER" "$DB_NAME" < "$HERE/api/seed.sql"
echo "Database $DB_NAME reset to seed data."
