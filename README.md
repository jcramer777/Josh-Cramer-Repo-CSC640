# To-Do Task API (HW4: Build, Verify, and Compare)

A small REST API (users, categories, tasks) built twice: **Stage 1** with raw PHP + MySQL behind NGINX, **Stage 2** with Laravel, Docker and a Hugo documentation site. Both stages must pass the same acceptance tests.

> Status: **Stage 1 code written; run `setup.sh` and the tests on your machine** (see below). Stage 2 not started.

## Contents

| Path | What |
|---|---|
| `acceptance.md` | Success and failure cases for all 10 endpoints, including token cases |
| `code/stage1/` | Stage 1: PHP + MySQL + NGINX (`api/`, `nginx/`, `setup.sh`, `run.sh`, `reset_db.sh`) |
| `code/tests/run_tests.sh` | Executable acceptance tests (shared by both stages) |
| `code/tests/results/` | Saved test results per stage |
| `plan/` | HW1 proposal text, `HW4_plan_stage1.md`, `HW4_plan_stage2.md`, Part 1 checklist |
| `presentation/` | Marp tutorial (Stage 1), Hugo site and `comparison.md` (Stage 2) |

## API (all under `/api`)

| Method and path | Auth |
|---|---|
| `POST /api/register`, `POST /api/login` | public |
| `GET /api/categories`, `GET /api/categories/{id}`, `GET /api/categories/{id}/tasks` | public |
| `GET /api/tasks`, `GET /api/tasks/{id}` | public |
| `POST /api/tasks`, `PUT /api/tasks/{id}`, `DELETE /api/tasks/{id}` | **bearer token** |

Responses are JSON: `{"success": true, "data": ...}` or `{"success": false, "error": "..."}`.

## Stage 1: setup, run, test

Prerequisites (Ubuntu / WSL2): `nginx`, `php-fpm`, `php-mysql`, `mysql-server`, `curl` (installers: ASE 230 `course_tools/`).

```bash
bash code/stage1/setup.sh                      # MySQL database/user, schema + seed data, NGINX site on port 8080
bash code/stage1/run.sh                        # start services later; checks http://localhost:8080/api
bash code/stage1/reset_db.sh                   # restore seed data before a test run
STAGE=stage1 bash code/tests/run_tests.sh      # acceptance tests; exit code 0 = all passed
```

- API: <http://localhost:8080/api>
- HTML/JavaScript test page: <http://localhost:8080/test.html>

## Stage 2

_Planned:_ Laravel (routes, controllers, Eloquent, Sanctum), `run.sh`, Docker Compose with `setup.sh`, Hugo tutorial on GitHub Pages, GitHub Actions, and `comparison.md`.

## Credits and AI assistance

- Reused and adapted from ASE 230 (nkuase/ase230): `module1/code/6_RestAPI/api/` (routing, JSON responses, PDO pattern, curl test style), `module1/code/5_Webserver_using_NGINX/nginx.conf` (NGINX + PHP-FPM), `module1/code/7_Security/Basics/bearer/` (bearer-token idea). Add lecture file names and page numbers where you used them.
- AI assistance: Claude (Anthropic) helped write the Stage 1 code, test script and planning documents. **Edit this line to describe exactly what you used it for, and make sure you can explain every file.**
