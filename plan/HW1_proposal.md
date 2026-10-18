# HW1: Option 2 One-Page Proposal (paste into `HW1_rubric.md`)

Paste these answers into the Assignment 3 section of `HW1_rubric.md`. Edit the wording so it is yours.

- **Option** (1 or 2): 2
- **Repository link**: _(create the GitHub repository, then paste the link here)_

## Problem

People who manage their own to-dos in notes or chats lose track of what is open and what belongs to which area of their life. I need a small server that stores tasks grouped by category (Work, Personal, School), lets anyone read them, and lets only registered, logged-in users create, change or delete tasks.

## 10 APIs (at least 2 must be bearer-token-protected)

| # | Method and path | Purpose | Auth |
|---|---|---|---|
| 1 | `POST /api/register` | Create a user account | public |
| 2 | `POST /api/login` | Check credentials and return a bearer token | public |
| 3 | `GET /api/categories` | List all categories | public |
| 4 | `GET /api/categories/{id}` | Get one category | public |
| 5 | `GET /api/categories/{id}/tasks` | List the tasks in one category | public |
| 6 | `GET /api/tasks` | List all tasks | public |
| 7 | `GET /api/tasks/{id}` | Get one task | public |
| 8 | `POST /api/tasks` | Create a task | **bearer token** |
| 9 | `PUT /api/tasks/{id}` | Replace a task (title, category, done) | **bearer token** |
| 10 | `DELETE /api/tasks/{id}` | Delete a task | **bearer token** |

**Stage 1 (HW4):** raw PHP and MySQL (PDO) served through NGINX.
**Stage 2 (HW4):** the same API rebuilt in Laravel (Eloquent models, Sanctum tokens), plus shell scripts, Docker, a Hugo documentation site and a GitHub Actions deployment to GitHub Pages.

## Rubric rows 3-2 and 4 reminders

- Row 3-2 (Option 2): read ASE 230 [module 1](https://github.com/nkuase/ase230/tree/main/module1/pdf) and [module 2](https://github.com/nkuase/ase230/tree/main/module2/pdf) PDFs. Only tick it after you have really read them.
- Row 4: you still need to create the documentation repository, enable GitHub Pages, and add your Canvas progress page link and your three peers' names (the professor emails them).
