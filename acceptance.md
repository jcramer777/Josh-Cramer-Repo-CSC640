# Acceptance Tests: To-Do Task API

These tests define "done" for both stages (Stage 1: PHP + MySQL behind NGINX; Stage 2: Laravel). They are **executable**:
`code/tests/run_tests.sh` checks the status code and the response content of every case, prints PASS/FAIL, and exits nonzero if anything fails. The test IDs below match the IDs in the script's output.

## How to run

```bash
# Stage 1 (PHP + MySQL + NGINX)
bash code/stage1/reset_db.sh                      # data setup: restore the seed data
STAGE=stage1 bash code/tests/run_tests.sh         # results -> code/tests/results/stage1_results.txt

# Stage 2 (Laravel): same script, same assertions
STAGE=stage2 BASE_URL=http://localhost:8080 bash code/tests/run_tests.sh
```

Requirements: `bash`, `curl`, `php` (used only to read JSON). Default `BASE_URL` is `http://localhost:8080`.

## Data setup

`code/stage1/api/seed.sql` (and the Laravel seeders in Stage 2) provide fixed data:

| Table | Seed rows |
|---|---|
| users | id 1, `seed@example.com`, password `password123` |
| categories | 1 = Work, 2 = Personal, 3 = School |
| tasks | 1 = "Finish HW4 plan" (done = false, category 3), 2 = "Buy groceries" (done = true, category 2) |

Each run also registers its own unique user (`tester_<timestamp>_<random>@example.com`) and logs in to get a bearer token, so runs do not collide. Tests never edit seed tasks 1 and 2; they create and delete their own task.

## Conventions

- Base path: `/api`. All responses are JSON: `{"success": true, "data": ...}` or `{"success": false, "error": "..."}`.
- Bearer token: `Authorization: Bearer <token>`. Authentication is checked **before** the body is validated, so a missing or bad token gives 401 even if the body is also invalid.
- Never weaken a test to hide a failure: if a test fails, fix the code.

## Endpoint contract and test cases

### 1. `POST /api/register` (public)

Body: `{"name", "email", "password"}`. Password: at least 6 characters.

| ID | Case | Request | Expected |
|---|---|---|---|
| R1 | Success | valid new user | 201, `success: true`, `data.email` equals the email sent, no `password` in the response |
| R2 | Failure: duplicate | same email again | 409 |
| R3 | Failure: missing fields | `{}` | 400 |
| R4 | Failure: invalid email | `"email": "not-an-email"` | 400 |
| R5 | Failure: short password | `"password": "123"` | 400 |

### 2. `POST /api/login` (public)

Body: `{"email", "password"}`. Returns a bearer token.

| ID | Case | Request | Expected |
|---|---|---|---|
| L1 | Success | valid credentials | 200, non-empty `token` |
| L2 | Failure: wrong password | wrong password | 401, no `token` in the response |
| L3 | Failure: missing fields | `{}` | 400 |

### 3. `GET /api/categories` (public)

| ID | Case | Expected |
|---|---|---|
| C1 | Success | 200, `success: true`, `data[0].name` = `Work` |

### 4. `GET /api/categories/{id}` (public)

| ID | Case | Request | Expected |
|---|---|---|---|
| C2 | Success | `/api/categories/1` | 200, `data.id` = 1 |
| C3 | Failure: unknown id | `/api/categories/999999` | 404 |
| C4 | Failure: non-numeric id | `/api/categories/abc` | 400 |

### 5. `GET /api/categories/{id}/tasks` (public)

| ID | Case | Request | Expected |
|---|---|---|---|
| C5 | Success | `/api/categories/3/tasks` | 200, `data[0].title` = `Finish HW4 plan` |
| C6 | Failure: unknown category | `/api/categories/999999/tasks` | 404 |

### 6. `GET /api/tasks` (public)

| ID | Case | Expected |
|---|---|---|
| T1 | Success | 200, `success: true` |

### 7. `GET /api/tasks/{id}` (public)

| ID | Case | Request | Expected |
|---|---|---|---|
| T2 | Success | `/api/tasks/1` | 200, `data.title` = `Finish HW4 plan`, `data.done` is boolean `false` |
| T3 | Failure: unknown id | `/api/tasks/999999` | 404 |
| T4 | Failure: non-numeric id | `/api/tasks/abc` | 400 |

### 8. `POST /api/tasks` (protected)

Body: `{"title", "category_id", "done"?}`. `done` defaults to `false`.

| ID | Case | Request | Expected |
|---|---|---|---|
| P1 | Success, valid token | valid body | 201, `data.title` matches, `data.done` = `false` |
| P2 | Failure: missing token | valid body, no header | 401 |
| P3 | Failure: invalid token | `Bearer invalid-token-123` | 401 |
| P4 | Failure: missing title | `{"category_id": 3}` | 400 |
| P5 | Failure: unknown category | `"category_id": 999999` | 400 |

### 9. `PUT /api/tasks/{id}` (protected)

Full replace: `title`, `category_id` and `done` are all required.

| ID | Case | Request | Expected |
|---|---|---|---|
| U1 | Success, valid token | valid full body | 200, `data.title` changed, `data.done` = `true` |
| U2 | Failure: missing token | valid body, no header | 401 |
| U3 | Failure: invalid token | bad token | 401 |
| U4 | Failure: incomplete body | `{"title": "Only a title"}` | 400 |
| U5 | Failure: unknown id | `/api/tasks/999999` | 404 |

### 10. `DELETE /api/tasks/{id}` (protected)

| ID | Case | Request | Expected |
|---|---|---|---|
| D1 | Failure: missing token | no header | 401 |
| D2 | Failure: invalid token | bad token | 401 |
| D3 | Success, valid token | the task created in P1 | 200, and a following `GET /api/tasks/{id}` returns 404 |
| D4 | Failure: unknown id | `/api/tasks/999999` | 404 |

### General routing

| ID | Case | Request | Expected |
|---|---|---|---|
| G1 | API root | `GET /api` | 200 |
| G2 | Unknown resource | `GET /api/unknown` | 404 |
| G3 | Method not allowed | `PATCH /api/tasks/1` | 405 |

## Protected endpoint coverage

Each protected endpoint is tested with a valid token (P1, U1, D3), a missing token (P2, U2, D1) and an invalid token (P3, U3, D2).

## Recording results

For every run, save the output of `run_tests.sh` (the script writes it to `code/tests/results/<stage>_results.txt`) and add a row here:

| Stage | Command | Expected | Actual | Date |
|---|---|---|---|---|
| Stage 1 | `STAGE=stage1 bash code/tests/run_tests.sh` | 52 passed, 0 failed | _fill in after running_ | |
| Stage 2 | `STAGE=stage2 bash code/tests/run_tests.sh` | 52 passed, 0 failed | _fill in after running_ | |
