---
marp: true
---

# HW4 - Stage 2 Plan

**Submission Deadline:** 12/10 (HW4 Part 3). Part 2 (this plan, with `stage1_evaluation.md`) is due 11/21.

---

## Your HW4 Part 3 Submission Date

1. **When (Plan):** 12/8
2. **When (Actual):** TBD
3. **Comment:** Two days before the deadline, because HW5 is also due 12/10.

---

## Stage 2 Milestones

### Milestone 1 Submission

1. **What:** Laravel trial: run the ASE 230 `run1-5.sh` and `test1-5.sh` example (Laravel install, MySQL, Sanctum bearer token) successfully on my machine
2. **When (Plan):** 11/12
3. **When (Actual):** 11/8
4. **Comment:** Finished early. `run1-5.sh` installed Laravel, MySQL and Sanctum, and `test1-5.sh` passed: a login returns a token, `/api/me` returns 401 with a missing or invalid token and 200 with a valid one, a student is created only with a token, and after logout the old token returns 401. The token table stores only hashed tokens, and tokens expire after one hour (my Stage 1 tokens never expire). Evidence: `plan/evidence/laravel_trial_*.png`.

---

### Milestone 2 Submission

1. **What:** Laravel To-Do API in `code/stage2/`: migrations, seeders with the same seed data as Stage 1, Eloquent models and relationships (no raw SQL), routes and controllers for all 10 endpoints
2. **When (Plan):** 11/24
3. **When (Actual):** TBD
4. **Comment:**

---

### Milestone 3 Submission

1. **What:** Sanctum bearer authentication on the 3 protected endpoints; `run.sh` starts Laravel; the same 52 acceptance assertions pass against Laravel; side-by-side Stage 1 / Stage 2 results saved; adapted shell script with explanation and references
2. **When (Plan):** 11/30
3. **When (Actual):** TBD
4. **Comment:**

---

### Milestone 4 Submission

1. **What:** Docker/Compose configuration (app + MySQL); `setup.sh` builds and starts the environment; the acceptance tests pass against the container
2. **When (Plan):** 12/2
3. **When (Actual):** TBD
4. **Comment:**

---

### Milestone 5 Submission

1. **What:** Hugo tutorial adapted from the Stage 1 tutorial; GitHub Actions builds and publishes it to GitHub Pages on push; half-page `comparison.md` with links to both test results
2. **When (Plan):** 12/4
3. **When (Actual):** TBD
4. **Comment:**

---

### Milestone 6 Submission

1. **What:** `stage2_evaluation.md` filled in with evidence links; README updated for both stages; no secrets committed; Plan vs Actual dates updated; Stage 2 tagged in GitHub
2. **When (Plan):** 12/7
3. **When (Actual):** TBD
4. **Comment:**

---

### Additional Milestones (if necessary)

1. **What:** Part 2 peer reviews of my three HW1 peers (`peer-review.md`, submitted on Canvas)
2. **When (Plan):** 11/22 (deadline 11/23)
3. **When (Actual):** TBD
4. **Comment:**

---

1. **What:** Part 3 peer reviews of my three HW1 peers
2. **When (Plan):** 12/11 (deadline 12/12)
3. **When (Actual):** TBD
4. **Comment:**
