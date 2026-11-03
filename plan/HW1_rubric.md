---
marp: true
html: true
size: 4:3
paginate: true
style: |
  section.small {
    font-size: 26px;
  }
---

<!-- _class: lead -->
<!-- _class: frontpage -->
<!-- _paginate: skip -->

# HW1 Rubric

Self-grade each row and submit only this file on Canvas.

---

## How to Grade Yourself

- **Each row is all-or-nothing**: full points when the row is completely done, 0 otherwise.
- **Installed** means the tool runs, for example, it prints its version (`node --version`).
  - You don't have to copy or screen capture anything for HW1.
- Write the earned points in the **Earned** column.
- Add the links and answers each row asks for; rows without the requested evidence earn 0.

---

## Assignment 1: Understand the Course (50)

<!-- _class: small -->

| Row | Done when | Points | Earned |
|---|---|---:|---|
| 1-1 | I read all PDFs in **On Board** and can read Marp files in VSCode | 10 |10 |
| 1-2 | I read all PDFs in **CSC 640** | 10 |10 |
| 1-3 | I skimmed (or read) all PDFs in **ASE Topics** (ASE 230, 285, and 420) | 10 |10 |
| 1-4 | I read all PDFs in **Assignments** and am ready for the five homework assignments | 10 |10 |
| 1-5 | I reviewed the course repositories below | 10 |10 |
| | **Total** | **50** |50 |

Repositories: [csc640](https://github.com/nkuase/csc640), [ASE](https://github.com/nkuase/ASE), [ase285](https://github.com/nkuase/ase285) (process and high-level language), [ase420](https://github.com/nkuase/ase420) (design), [ase230](https://github.com/nkuase/ase230) (project preparation)

---

## Assignment 2: Install the Tools (50)

<!-- _class: small -->

| Row | Done when | Points | Earned |
|---|---|---:|---|
| 2-1 | CLI ready: WSL2 on Windows; terminal and bash on Mac/Linux | 10 |10 |
| 2-2 | Node.js installed | 10 |10 |
| 2-3 | Python installed | 10 |10 |
| 2-4 | Every other tool for your project (including docker and hugo of ASE 230 module3) | 20 |20 |
| | **Total** | **50** |50 |

---

## Assignment 3: Choose Your Project (50)

<!-- _class: small -->

| Row | Done when | Points | Earned |
|---|---|---:|---|
| 3-1 | I chose an option and completed the one-page proposal below | 20 |20 |
| 3-2 | **Option 1**: I emailed the professor to schedule a meeting (date below). **Option 2**: I read ASE 230 [module 1](https://github.com/nkuase/ase230/tree/main/module1/pdf) (Stage 1) and [module 2](https://github.com/nkuase/ase230/tree/main/module2/pdf) (Stage 2) | 20 |20 |
| 3-3 | I created a GitHub repository for the project (link below) | 10 |10 |
| | **Total** | **50** |50 |

---

### Assignment 3 Answers

- **Option** (1 or 2): 2
- **Repository link**: https://github.com/Jcramer777/Josh-Cramer-Repo-CSC640
- **Option 1 only**, date of the meeting email: N/A (I chose Option 2)

Complete the One-Page Proposal for your chosen option below.

---

### Option 1: One-Page Proposal

<!-- _class: small -->

- **Problem**: What is the problem that you need to solve?
> N/A (I chose Option 2)

- **Solution**: What is your solution to the problem?
> N/A (I chose Option 2)

---

### Option 1: One-Page Proposal (cont.)

<!-- _class: small -->

- **Stage 1 tool** (working baseline):
> N/A (I chose Option 2)

- **Stage 2 tool** (higher-level tools or framework):
> N/A (I chose Option 2)

- **Automation tools** (e.g., Docker, GitHub Actions):
> N/A (I chose Option 2)

Even with Option 1, plan to use the ASE 230 Module 3 tools (Docker, Hugo, and GitHub) to document and automate your project.

---

### Option 2: One-Page Proposal

<!-- _class: small -->

- **Problem**: What is the problem that you need to solve using the API server?
> People who manage their own to-dos in notes or chats lose track of what is open and what belongs to which area of their life. I need a small server that stores tasks grouped by category (Work, Personal, School), lets anyone read them, and lets only registered, logged-in users create, change or delete tasks.


---

### Option 2: One-Page Proposal (cont.)

<!-- _class: small -->

- **10 APIs** (at least 2 must be bearer-token-protected APIs):
> 1. `POST /api/register`: create a user account (public)
> 2. `POST /api/login`: check credentials and return a bearer token (public)
> 3. `GET /api/categories`: list all categories (public)
> 4. `GET /api/categories/{id}`: get one category (public)
> 5. `GET /api/categories/{id}/tasks`: list the tasks in one category (public)
> 6. `GET /api/tasks`: list all tasks (public)
> 7. `GET /api/tasks/{id}`: get one task (public)
> 8. `POST /api/tasks`: create a task (**bearer token**)
> 9. `PUT /api/tasks/{id}`: replace a task (**bearer token**)
> 10. `DELETE /api/tasks/{id}`: delete a task (**bearer token**)

---

## Assignment 4: Prepare for HW5 (50)

<!-- _class: small -->

| Row | Done when | Points | Earned |
|---|---|---:|---|
| 4-1 | I read ASE 230 [module 3](https://github.com/nkuase/ase230/tree/main/module3/pdf) (documentation tools: Hugo and GitHub Pages), even if I chose Option 1 | 10 |10 |
| 4-2 | I checked all HW5 items below | 20 |20|
| 4-3 | I created a documentation repository (link below) | 10 |10 |
| 4-4 | I enabled GitHub Pages for it, and the link opens (an empty or placeholder page is fine) | 10 |10| 
| | **Total** | **50** |50|

---

### HW5 Items

- [x] HW5 teaches future team members how to build quality software.
- [x] HW5 uses my HW4 project as evidence, not only a summary of course materials.
- [x] I may use course materials, but I must add my own understanding.
- [x] I will publish the report with Hugo (or a similar system) on GitHub Pages, and write the presentation in Marp.

---

### HW5 Items (cont.)

<!-- _class: small -->

- [x] I will update the document throughout the semester using GitHub.
  - **Documentation repository link**: https://github.com/Jcramer777/csc640-docs
  - **GitHub Pages link**: https://jcramer777.github.io/csc640-docs/
- [x] I will update the progress throughout the semester using Canvas.
  - **Canvas progress page link**: https://nku.instructure.com/courses/92884/pages/individual-project-progress-page-of-josh-cramer-in-csc640
- [x] I know the three assigned peers (assigned by the professor through email) to check progress and evaluate for HW4 and HW5.
  - Student 1: Austin Kidwell
  - Student 2: Minh Son Le
  - Student 3: Nguyen Ngoc Nga Phan

---

## Total

| Assignment | Points | Earned |
|---|---:|---|
| 1. Understand the Course | 50 |50|
| 2. Install the Tools | 50 |50|
| 3. Choose Your Project | 50 |50|
| 4. Prepare for HW5 | 50 |50| 
| **Total** | **200** |200|

---

## Questions (Not Graded)

Anything unclear or confusing in the course materials? Write it here; it helps improve the course.

>

---

## Before You Submit

- [x] I answered every row honestly and added the requested links.
- [x] I understand the instructor can regrade my submission; points are deducted for false claims or missing evidence (for example, a checked row that was not done or a broken link), and integrity violations earn 0.
- [x] I will use HW1 answers for my HW5 submission.
- [x] I am submitting only `HW1_rubric.md` on Canvas.
