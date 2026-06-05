---
name: execute-plan
description: "Executes a PLAN.md end to end: clarify, revise the plan, implement as small commits, and push often for human review. Use when the operator asks to execute, implement, or work through a plan."
license: MIT
metadata:
  source: https://github.com/mrs-electronics-inc/agent-skills
---

# Execute Plan

Drives a `PLAN.md` from revision to an implemented, reviewable branch.

## Guidelines

### Always Do (no asking)

- Verify `PLAN.md` exists at the repo root and read it. If it is missing, stop and ask the operator — do not create it from scratch.
- Treat `PLAN.md` as the source of truth; rewrite it when reality differs.
- Ask focused clarifying questions when the plan is ambiguous, under-specified, or contradicts existing code or conventions. One question per turn when possible.
- Revise `PLAN.md` to reflect new decisions, then commit it as `docs: revise plan` (or `docs(<scope>): revise plan`) before any implementation commits.
- Break implementation into small, scoped commits — one logical change each.
- Use Conventional Commits for all commits, with a scoped type when it adds clarity.
- Match the target project's existing conventions (apps/packages touched, naming, patterns, public APIs) by reading its `AGENTS.md` and neighboring code.
- Cover new or changed behavior with tests in the same commit as the behavior.
- Push the branch often so the human can review in the draft PR.

### Ask First (pause for approval)

- Decisions that expand scope, change public APIs, or touch hardware/infra.
- Re-architecting parts of the plan vs. executing it as written.
- Merging, rebasing against the base branch, or any history rewriting.

### Never Do (hard stop)

- Run linters, formatters, or other repo-wide checks directly. Pre-commit hooks handle these.
- Run tests directly. CI/CD pipelines run them.
- Create the draft PR. The human opens it.
- Amend commits after hooks fail. Create a fresh commit.
- Mix unrelated cleanup into a feature commit.
- Hand-edit generated files when the source can be regenerated.
- Widen production APIs to satisfy tests or commit ordering.

## Workflow

### 1. Read and Internalize

- Read `PLAN.md` and the project's `AGENTS.md` fully.
- Survey referenced files, apps, and packages to understand current state.
- Note any mismatch between the plan and reality (missing files, renamed APIs, conflicting conventions).

### 2. Clarify

- For each ambiguity or gap, ask the operator a focused question.
- Prefer one question at a time when answers shape downstream work.
- Stop clarifying only when the next 1-3 implementation steps are unambiguous.

### 3. Revise PLAN.md

- Update `PLAN.md` to incorporate decisions, corrections, and new details.
- Keep it concise; favor concrete bullets over prose.
- Commit with message `docs: revise plan` (or `docs(<scope>): revise plan` when the plan is scoped).

### 4. Implement in Small Commits

- Slice the work into the smallest logical commits that each leave the tree in a coherent state.
- Order commits so each one builds on the previous; avoid broken intermediate states on shared branches.
- Use the project's build/codegen tooling (e.g. `moon`, build-runner, schema generation) when the affected files require it.

### 5. Push Often

- Push after each meaningful commit (or small group) so the draft PR diff stays reviewable.
- Do not create the PR; tell the operator when the branch is ready and let them open it.
- If a push is rejected, stop and ask before force-pushing or rebasing.

### 6. Report Back

- Summarize what was implemented, commit-by-commit.
- Flag anything that deviated from the plan and why.
- Note follow-ups, deferred items, or open questions for the operator.

## Completion Checklist

- `PLAN.md` reflects the final, agreed approach.
- Branch is pushed and the human has been told it is ready for PR review.
- All Never Do rules were respected (no direct lint/test runs, no draft PR opened, no amended commits).
