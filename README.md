# To-Do Task API (HW4: Build, Verify, and Compare)

A small REST API (users, categories, tasks) built twice: **Stage 1** with raw PHP + MySQL behind NGINX, **Stage 2** with Laravel, Docker and a Hugo documentation site. Both stages must pass the same acceptance tests.

> **Submitted version (HW4 Part 2): Stage 1**, directory `code/stage1/` (tag `stage1`). Stage 2 is added in `code/stage2/` later and does not change Stage 1.
>
> Status: **Stage 1 working** through NGINX with MySQL; 52 of 52 acceptance assertions pass (see [`code/tests/results/stage1_results.txt`](code/tests/results/stage1_results.txt)). Stage 2: the course's Laravel example (`run1-5.sh`) was run successfully on 11/8 as a trial (evidence in [`plan/evidence/`](plan/evidence/)); the Laravel To-Do API itself is not started.

## Contents

| Path | What |
|---|---|
| `acceptance.md` | Success and failure cases for all 10 endpoints, including token cases |
| `code/stage1/` | Stage 1: PHP + MySQL + NGINX (`api/`, `nginx/`, `setup.sh`, `run.sh`, `reset_db.sh`) |
| `code/tests/run_tests.sh` | Executable acceptance tests (shared by both stages) |
| `code/tests/results/` | Saved test results per stage; `test_page/` has screenshots of the HTML/JavaScript test page |
| `presentation/stage1_tutorial.md` and `.pdf` | Stage 1 Marp tutorial: every endpoint with request and response examples |
| `plan/` | `HW4_plan_stage1.md`, `HW4_plan_stage2.md` (Plan vs Actual dates), `stage1_evaluation.md` (self-evaluation), Part 1 checklist, HW1 proposal text; `evidence/` has the Laravel trial screenshots |
| `presentation/` | Marp tutorial (Stage 1); Hugo site and `comparison.md` (Stage 2, planned) |

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

**Reused and adapted from ASE 230** ([`nkuase/ase230`](https://github.com/nkuase/ase230)):

- `module1/code/6_RestAPI/api/` (`index.php`, `handlers_pdo.php`, `database.php`, `schema.sql`) for the front controller, JSON responses and PDO pattern.
- `module1/code/6_RestAPI/api_tests/curl/` for the curl-based test style.
- `module1/code/5_Webserver_using_NGINX/nginx.conf` for NGINX with PHP-FPM.
- `module1/code/7_Security/Basics/bearer/` for the bearer-token idea.
- `module2/code/1_Laravel/5. Bearer Token APIs/` (`run1-5.sh`, `test1-5.sh`) for the Stage 2 Laravel trial only; no Stage 1 code comes from it.

**Related lecture slides** (ASE 230 `module1/pdf/`): the code above follows the topics of `5_Webserver_using_NGINX/2. Setting up NGINX for PHP.pdf`, `6_RestAPI/2. Building REST API Server with PHP and JSON.pdf`, `6_RestAPI/3. Connecting REST API Server to MySQL with PDO.pdf` and `6_RestAPI/4. Testing REST API Server.pdf`. I built from the course code files listed above, not from specific slide pages, so I cite no page numbers.

**AI assistance:** Claude (Anthropic) wrote the first drafts of the Stage 1 code (`index.php`, SQL, NGINX config, scripts), the acceptance test script, the HTML test page, and the plan, tutorial and evaluation documents. I ran the setup, the 52 acceptance tests, the test page and the Laravel trial on my own machine (WSL2 Ubuntu, MySQL, NGINX), fixed the NGINX port 80 conflict there, and the scores in `plan/stage1_evaluation.md` come from those runs. The request and response examples in the Stage 1 tutorial were first captured against a test copy of the API that uses SQLite, then the real MySQL version was checked with the same acceptance tests (52 passed, 0 failed).
