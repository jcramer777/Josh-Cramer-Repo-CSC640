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

Self-score each row and link to evidence. Full credit requires the stated working behavior and evidence. Partial credit reflects the proportion correctly demonstrated. Round proportional scores to the nearest 0.5 point. Missing or nonworking evidence earns no credit for that part. The final score combines your three peers' reviews and the instructor's evaluation.

---

## Schedule (20 points)

| Criterion | Points | Earned |
|---|---:|---|
| Milestones in `HW4_plan_stage1.md` were completed on or before their planned dates; score = 10 × milestones on time ÷ total milestones | 10 | [4/10] (2 of 5 milestones on time: M2, M3; see E8) |
| Plan vs Actual dates were recorded and kept up to date throughout, and changes are explained | 10 | [7/10] (all five milestones have actual dates and comments; M1, M4 and M5 were late; the plan was written after M2 and M3 were done, which the plan says; see E8) |
| **Total** | **20** | **[11/20]** |

---

## Implementation and Quality (60 points)

Evaluate everything below on the API **running through NGINX**; a working program means NGINX works.

For Option 1, you earn each row's points by implementing the equivalent feature.

---

| Criterion | Points | Earned |
|---|---:|---|
| HW1-approved PHP/MySQL endpoint set matches the documented contract; score = 20 × working endpoints ÷ approved endpoints | 20 | [20/20] (10 of 10 endpoints; see E1) |
| HW1-approved protected endpoints support valid access and reject missing/invalid tokens; score = 10 × fully verified protected endpoints ÷ approved protected endpoints | 10 | [10/10] (3 of 3; see E2) |

---

## Implementation and Quality (cont.)

| Criterion | Points | Earned |
|---|---:|---|
| Executable acceptance tests for every endpoint: success and relevant failure assertions, reproducible data, saved pass/fail results | 15 | [15/15] (see E3) |
| HTML/JavaScript test page calls every endpoint and displays success/error results | 5 | [5/5] (see E4) |
| MySQL CRUD works with documented schema and setup | 10 | [10/10] (see E5) |
| **Total** | **60** | **[60/60]** |

---

## Tutorial and Reproducibility (20 points)

| Criterion | Points | Earned |
|---|---:|---|
| Marp tutorial explains every endpoint's method/path, inputs, outputs, and authentication; submit Markdown and PDF (no minimum page count) | 10 | [10/10] (see E6) |
| Correct successful and failed request/response examples | 5 | [5/5] (see E6) |
| README in the GitHub repository identifies the submitted version and links setup, run, and test instructions that a reviewer can follow | 5 | [5/5] (see E7) |
| **Total** | **20** | **[20/20]** |

---

## Evidence Links

Schedule scores are explained under E8. The test page was checked by hand in a browser on 11/8/2026.

| ID | Evidence |
|---|---|
| E1 | 10 endpoints implemented in [`code/stage1/api/index.php`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/stage1/api/index.php); all passed through NGINX on port 8080: [`stage1_results.txt`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/tests/results/stage1_results.txt) (52 passed, 0 failed) |
| E2 | Protected endpoints `POST`, `PUT`, `DELETE /api/tasks`: valid, missing and invalid token cases P1-P3, U1-U3, D1-D3 in [`stage1_results.txt`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/tests/results/stage1_results.txt) and [`acceptance.md`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/acceptance.md) |
| E3 | [`acceptance.md`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/acceptance.md) (success and failure cases, data setup), [`run_tests.sh`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/tests/run_tests.sh) (exits nonzero on failure), saved results in [`stage1_results.txt`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/tests/results/stage1_results.txt) |
| E4 | Test page [`test.html`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/stage1/api/test.html), checked in a browser on 11/8/2026 with all 10 endpoints returning the expected result. Screenshots: [register, login, categories](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/tests/results/test_page/test_page_register_login_categories.png), [public GET endpoints](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/tests/results/test_page/test_page_public_gets.png), [protected endpoints with a valid token](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/tests/results/test_page/test_page_protected_success.png), [error display, 401 without a token](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/tests/results/test_page/test_page_error_401_no_token.png) |
| E5 | Schema [`schema.sql`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/stage1/api/schema.sql), seed data [`seed.sql`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/stage1/api/seed.sql), setup [`setup.sh`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/stage1/setup.sh), PDO access in [`index.php`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/code/stage1/api/index.php) |
| E6 | Tutorial: [`stage1_tutorial.md`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/presentation/stage1_tutorial.md) and [`stage1_tutorial.pdf`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/presentation/stage1_tutorial.pdf) |
| E7 | [`README.md`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/README.md) names the submitted version (Stage 1) and links setup, run and test steps |
| E8 | Schedule: [`HW4_plan_stage1.md`](https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640/blob/main/plan/HW4_plan_stage1.md). M1 (plan 11/2, actual 11/8) and M4 (plan 11/5, actual 11/8) were late; M2 and M3 (actual 10/17) were on time; M5 (plan 11/6, actual 11/8) was also late, so 2 of 5 were on time = 4 of 10. The plan was written on 11/2, after M2 and M3 were already done, and it says so. |

---

## Final Checks

- [ ] My HW1 GitHub repository has `code/`, `presentation/`, and `plan/`, with `acceptance.md`, tests/results, and README.
- [ ] Published source and documentation on GitHub; the link is on my HW1 Canvas progress page.
- [ ] Cited reused work (lecture slides by file name and page) and AI assistance; I can explain my implementation and tests.
- [ ] I will submit `peer-review.md` (from `peer-review-example.md`) on Canvas (HW4 Part 2 Peer Review).

**Total: [91/100]** (Schedule 20 + Implementation 60 + Tutorial 20)
