#!/bin/bash
# Executable acceptance tests for the To-Do Task API. The SAME script runs against Stage 1 (PHP) and Stage 2 (Laravel).
#
#   STAGE=stage1 bash code/tests/run_tests.sh      # default base URL http://localhost:8080
#   STAGE=stage2 BASE_URL=http://localhost:8080 bash code/tests/run_tests.sh
#
# Data setup: the database must contain the seed data (categories 1-3, tasks 1-2, user seed@example.com).
# For Stage 1 run `bash code/stage1/reset_db.sh` first. Each run registers its own unique user.
# Exits 0 only if every assertion passes; results are saved to code/tests/results/<stage>_results.txt.
# Requires: bash, curl, php (used to read JSON). Test IDs match acceptance.md.

BASE_URL="${BASE_URL:-http://localhost:8080}"
STAGE="${STAGE:-stage1}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS="$HERE/results/${STAGE}_results.txt"
mkdir -p "$HERE/results"
BODY_FILE="$(mktemp)"
trap 'rm -f "$BODY_FILE"' EXIT

PASS=0
FAIL=0
STATUS=""
TOKEN=""
TASK_ID=""

log() { echo "$*" | tee -a "$RESULTS"; }

# call METHOD PATH [JSON_BODY] [TOKEN]   -> sets STATUS, writes the response to $BODY_FILE
call() {
  local method="$1" path="$2" data="${3:-}" token="${4:-}"
  local args=(-s -o "$BODY_FILE" -w "%{http_code}" -X "$method" -H "Accept: application/json")
  [ -n "$data" ] && args+=(-H "Content-Type: application/json" -d "$data")
  [ -n "$token" ] && args+=(-H "Authorization: Bearer $token")
  STATUS="$(curl "${args[@]}" "$BASE_URL$path")"
}

# json_get a.b.c  -> value of that key in the last response ("" if missing)
json_get() {
  php -r '$v = json_decode(file_get_contents($argv[1]), true);
          foreach (explode(".", $argv[2]) as $k) { if (!is_array($v) || !array_key_exists($k, $v)) exit(0); $v = $v[$k]; }
          echo is_bool($v) ? ($v ? "true" : "false") : (is_scalar($v) ? $v : json_encode($v));' "$BODY_FILE" "$1"
}

record() { # record ID description ok detail
  if [ "$3" = "1" ]; then PASS=$((PASS+1)); log "PASS  $1  $2"; else FAIL=$((FAIL+1)); log "FAIL  $1  $2  -- $4"; fi
}

expect_status() { # ID desc expected
  [ "$STATUS" = "$3" ] && record "$1" "$2 (status $3)" 1 || record "$1" "$2" 0 "expected status $3, got $STATUS; body: $(head -c 200 "$BODY_FILE")"
}

expect_json() { # ID desc path expected
  local actual; actual="$(json_get "$3")"
  [ "$actual" = "$4" ] && record "$1" "$2 ($3 = $4)" 1 || record "$1" "$2" 0 "expected $3 = '$4', got '$actual'"
}

expect_nonempty() { # ID desc path
  local actual; actual="$(json_get "$3")"
  [ -n "$actual" ] && record "$1" "$2 ($3 present)" 1 || record "$1" "$2" 0 "$3 is missing or empty"
}

expect_not_contains() { # ID desc text
  grep -q "$3" "$BODY_FILE" && record "$1" "$2" 0 "response unexpectedly contains '$3'" || record "$1" "$2 (no '$3' in response)" 1
}

# ----------------------------------------------------------------------------
: > "$RESULTS"
log "Stage: $STAGE"
log "Command: STAGE=$STAGE BASE_URL=$BASE_URL bash code/tests/run_tests.sh"
log "Date: $(date '+%Y-%m-%d %H:%M:%S %Z')"
log "----------------------------------------------------------------"

if ! curl -s -o /dev/null "$BASE_URL/api"; then
  log "FAIL  SETUP  server not reachable at $BASE_URL"
  exit 1
fi

EMAIL="tester_$(date +%s)_$RANDOM@example.com"
PASSWORD="secret123"

# --- POST /api/register ------------------------------------------------------
call POST /api/register "{\"name\":\"Test User\",\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}"
expect_status R1 "register: valid user" 201
expect_json R1 "register: valid user" success true
expect_json R1 "register: returns email" data.email "$EMAIL"
expect_not_contains R1 "register: no password leaked" "password"
call POST /api/register "{\"name\":\"Test User\",\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}"
expect_status R2 "register: duplicate email rejected" 409
call POST /api/register '{}'
expect_status R3 "register: missing fields rejected" 400
call POST /api/register '{"name":"X","email":"not-an-email","password":"secret123"}'
expect_status R4 "register: invalid email rejected" 400
call POST /api/register '{"name":"X","email":"short@example.com","password":"123"}'
expect_status R5 "register: short password rejected" 400

# --- POST /api/login ---------------------------------------------------------
call POST /api/login "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}"
expect_status L1 "login: valid credentials" 200
expect_nonempty L1 "login: returns token" token
TOKEN="$(json_get token)"
call POST /api/login "{\"email\":\"$EMAIL\",\"password\":\"wrong-password\"}"
expect_status L2 "login: wrong password rejected" 401
expect_not_contains L2 "login: no token on failure" '"token"'
call POST /api/login '{}'
expect_status L3 "login: missing fields rejected" 400

# --- GET /api/categories, /api/categories/{id}, /api/categories/{id}/tasks ----
call GET /api/categories
expect_status C1 "categories: list" 200
expect_json C1 "categories: list has seed rows" success true
expect_json C1 "categories: first seed category" data.0.name Work
call GET /api/categories/1
expect_status C2 "category: get existing" 200
expect_json C2 "category: id" data.id 1
call GET /api/categories/999999
expect_status C3 "category: unknown id" 404
call GET /api/categories/abc
expect_status C4 "category: non-numeric id" 400
call GET /api/categories/3/tasks
expect_status C5 "category tasks: existing category" 200
expect_json C5 "category tasks: seed task title" data.0.title "Finish HW4 plan"
call GET /api/categories/999999/tasks
expect_status C6 "category tasks: unknown category" 404

# --- GET /api/tasks, /api/tasks/{id} -----------------------------------------
call GET /api/tasks
expect_status T1 "tasks: list" 200
expect_json T1 "tasks: success flag" success true
call GET /api/tasks/1
expect_status T2 "task: get existing" 200
expect_json T2 "task: title" data.title "Finish HW4 plan"
expect_json T2 "task: done is boolean false" data.done false
call GET /api/tasks/999999
expect_status T3 "task: unknown id" 404
call GET /api/tasks/abc
expect_status T4 "task: non-numeric id" 400

# --- POST /api/tasks (protected) ---------------------------------------------
NEW_TASK='{"title":"Write acceptance tests","category_id":3}'
call POST /api/tasks "$NEW_TASK" "$TOKEN"
expect_status P1 "create task: valid token" 201
expect_json P1 "create task: title" data.title "Write acceptance tests"
expect_json P1 "create task: done defaults to false" data.done false
TASK_ID="$(json_get data.id)"
call POST /api/tasks "$NEW_TASK"
expect_status P2 "create task: missing token" 401
call POST /api/tasks "$NEW_TASK" "invalid-token-123"
expect_status P3 "create task: invalid token" 401
call POST /api/tasks '{"category_id":3}' "$TOKEN"
expect_status P4 "create task: missing title" 400
call POST /api/tasks '{"title":"Orphan","category_id":999999}' "$TOKEN"
expect_status P5 "create task: unknown category_id" 400

# --- PUT /api/tasks/{id} (protected) -----------------------------------------
UPDATE='{"title":"Write acceptance tests (done)","category_id":3,"done":true}'
call PUT "/api/tasks/$TASK_ID" "$UPDATE" "$TOKEN"
expect_status U1 "update task: valid token" 200
expect_json U1 "update task: title changed" data.title "Write acceptance tests (done)"
expect_json U1 "update task: done is true" data.done true
call PUT "/api/tasks/$TASK_ID" "$UPDATE"
expect_status U2 "update task: missing token" 401
call PUT "/api/tasks/$TASK_ID" "$UPDATE" "invalid-token-123"
expect_status U3 "update task: invalid token" 401
call PUT "/api/tasks/$TASK_ID" '{"title":"Only a title"}' "$TOKEN"
expect_status U4 "update task: incomplete body" 400
call PUT /api/tasks/999999 "$UPDATE" "$TOKEN"
expect_status U5 "update task: unknown id" 404

# --- DELETE /api/tasks/{id} (protected) --------------------------------------
call DELETE "/api/tasks/$TASK_ID"
expect_status D1 "delete task: missing token" 401
call DELETE "/api/tasks/$TASK_ID" "" "invalid-token-123"
expect_status D2 "delete task: invalid token" 401
call DELETE "/api/tasks/$TASK_ID" "" "$TOKEN"
expect_status D3 "delete task: valid token" 200
call GET "/api/tasks/$TASK_ID"
expect_status D3 "delete task: task is gone afterwards" 404
call DELETE /api/tasks/999999 "" "$TOKEN"
expect_status D4 "delete task: unknown id" 404

# --- general routing ---------------------------------------------------------
call GET /api
expect_status G1 "api root: info" 200
call GET /api/unknown
expect_status G2 "unknown resource" 404
call PATCH /api/tasks/1 '{}' "$TOKEN"
expect_status G3 "method not allowed" 405

# ----------------------------------------------------------------------------
log "----------------------------------------------------------------"
log "Passed: $PASS   Failed: $FAIL   Total: $((PASS+FAIL))"
if [ "$FAIL" -eq 0 ]; then log "RESULT: ALL TESTS PASSED"; exit 0; else log "RESULT: FAILURES"; exit 1; fi
