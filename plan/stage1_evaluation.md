---
marp: true
html: true
size: 4:3
paginate: true
style: |
  section.small {
    font-size: 22px;
  }
---

# Stage 1 Evaluation

**Total: 100 points.** Submit in HW4 Part 2.

See `HW4.md` for common requirements and peer review. The criteria below describe Option 2; Option 1 uses the equivalent for its approved project.

---

## Self-Grading Rules

Self-score each row and link to evidence. Full credit requires the stated working behavior and evidence. Partial credit reflects the proportion correctly demonstrated. Round proportional scores to the nearest 0.5 point. Missing or nonworking evidence earns no credit for that part. Submit this evaluation first; then complete the assigned peer reviews after the Part deadline. The instructor confirms the final 0–100 score after considering the self-evaluation, peer reviews, and submitted evidence; peer scores are not averaged mechanically.

---

## Schedule (20 points)

| Criterion | Points | Earned |
|---|---:|---|
| Milestones in `HW4_plan_stage1.md` were completed on or before their planned dates; score = 10 × milestones on time ÷ total milestones | 10 | [4/10] |
| Plan vs Actual dates were recorded and kept up to date throughout, and changes are explained (master copy in `plan/`, linked from your Canvas progress page) | 10 | [8/10] |
| **Total** | **20** | **[12/20]** |

Reason: 2 of 5 milestones were on time (M2, M3) and M1, M4, M5 were late, each with an explanation. 8/10 because plan dates for M2 and M3 were written on 11/2, after the work was done.

---

## Implementation and Quality (60 points)

Evaluate everything below on the API **running through NGINX**; a working program means NGINX works.

For Option 1, you earn each row's points by implementing the equivalent feature.

---

| Criterion | Points | Earned |
|---|---:|---|
| HW1-approved PHP/MySQL endpoint set matches the documented contract; score = 20 × working endpoints ÷ approved endpoints | 20 | [20/20] |
| HW1-approved protected endpoints support valid access and reject missing/invalid tokens; score = 10 × fully verified protected endpoints ÷ approved protected endpoints. For an Option 1 project without protected endpoints, use the instructor-approved equivalent recorded in `acceptance.md`. | 10 | [10/10] |

Reason: Endpoints: 10 of 10 have passing tests in my 11/17 run (52 passed, 0 failed): register R1-R5, login L1-L3, list categories C1, get category C2-C4, category tasks C5-C6, list tasks T1, get task T2-T4, create task P1-P5, update task U1-U5, delete task D1-D4. Protected: 3 of 3 fully verified, each with valid, missing and invalid token tests (POST P1-P3, PUT U1-U3, DELETE D1-D3).

---

## Implementation and Quality (cont.)

| Criterion | Points | Earned |
|---|---:|---|
| Executable acceptance tests for every endpoint: success and relevant failure assertions, reproducible data, saved pass/fail results | 15 | [14/15] |
| HTML/JavaScript test page calls every endpoint and displays success/error results | 5 | [5/5] |
| MySQL CRUD works with documented schema and setup | 10 | [10/10] |
| **Total** | **60** | **[59/60]** |

Reason: Acceptance tests (14/15): all 10 endpoints have success tests and every endpoint except the two plain lists (`GET /api/categories`, test C1, and `GET /api/tasks`, test T1) also has failure tests, so I took one point off; `reset_db.sh` restores the seed data before each run, and the results are saved in `code/tests/results/stage1_results.txt` (52 passed, 0 failed on 11/17). Test page (5/5): it has a card for each of the 10 endpoints and shows green success and red error results; evidence is `2026-11-17_register_login_categories.png`, `2026-11-17_category_and_task_reads.png` and `2026-11-17_protected_401_no_token.png` in `code/tests/results/test_page/`. MySQL CRUD (10/10): I queried the `todo_api` database directly with `mysql` and saw the tables `api_tokens`, `categories`, `tasks` and `users`; the tasks I created through the test page on 11/17 (ids 4 and 5) are rows in `tasks`, the task I deleted is gone, and the users I registered are in `users`, which matches what the API returned. The schema is in `code/stage1/api/schema.sql` and the setup is in `setup.sh` and the README.

---

## Tutorial and Reproducibility (20 points)

| Criterion | Points | Earned |
|---|---:|---|
| Marp tutorial explains every endpoint's method/path, inputs, outputs, and authentication; submit Markdown and PDF (no minimum page count) | 10 | [10/10] |
| Correct successful and failed request/response examples | 5 | [5/5] |
| README in the GitHub repository identifies the submitted version and links setup, run, and test instructions that a reviewer can follow | 5 | [5/5] |
| **Total** | **20** | **[20/20]** |

Reason: Marp tutorial (10/10): `presentation/stage1_tutorial.md` and `stage1_tutorial.pdf` are both in the repo; the tutorial has a table of all 10 endpoints with method, path and auth (7 public, 3 bearer token) and a section for each endpoint with its inputs, outputs and failure cases, plus a bearer token flow section. Examples (5/5): on 11/17 I ran three of the tutorial's examples against my running API with `curl` (a success on `GET /api/categories/1`, a failure on `GET /api/tasks/999999`, and a protected `POST /api/tasks` without a token) and the responses matched the tutorial, apart from the timestamp, which the tutorial shows as `"..."`. README (5/5): it names the submitted version (Stage 1, directory `code/stage1/`, tag `stage1`) and links the setup, run and test commands and the results.

---

## Final Checks

- [x] My HW1 GitHub repository has `code/`, `presentation/`, and `plan/`, with `acceptance.md`, tests/results, and README.
- [x] Published source and documentation on GitHub; the link is on my HW1 Canvas progress page.
- [x] Cited reused work (lecture slides by file name and page) and AI assistance; I can explain my implementation and tests.
- [x] I will submit `peer-review.md` (from `peer-review-example.md`) on Canvas (HW4 Part 2 Peer Review).

**Total: [91/100]** (Schedule 20 + Implementation 60 + Tutorial 20)
