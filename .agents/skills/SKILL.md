---
name: handle-new-todos
description: "Scans TODO markers introduced by the current branch and ensures each is resolved or tracked. Use at the end of a PR, especially after review feedback."
license: MIT
metadata:
  source: https://git.kwila.cloud/kwila/karriba/src/branch/main/.agents/skills/handle-new-todos/SKILL.md
---

# Handle New TODOs

Use this skill at the end of a PR, especially after review feedback, to ensure TODO markers are either implemented now or explicitly tracked.

## Scope

- Scan TODO markers introduced by the current branch only.
- Base branch can be `origin/main` or `origin/develop` (or any explicit branch).
- Resolve base branch in this order:
  1. Explicit operator-provided base branch
  2. `origin/develop` if it exists
  3. `origin/main` if `origin/develop` does not exist

- Diff range is `$(git merge-base HEAD <base-branch>)..HEAD`.
- Only inspect added diff lines (`+` lines), excluding diff metadata (`+++`).

TODO marker: `TODO`.

## Hard Policy

Every introduced TODO marker must be resolved before closure using exactly one path:

1. Implement now in this PR, then remove marker (or replace with normal non-TODO explanatory comment).
2. Defer with tracker, and convert marker to one of these exact formats:
   - `TODO()`
   - `TODO(spec)`

Any deferred marker not matching one of those patterns is blocking.

## Detection Workflow

1. Compute merge-base against the selected base branch.
2. Collect added lines from branch diff.
3. Extract TODO matches with file and line number.
4. Capture context (nearest symbol/function/class) when straightforward.

Example detection command pattern:

```
BASE_BRANCH=origin/develop
git show-ref --verify --quiet refs/remotes/origin/develop || BASE_BRANCH=origin/main
git diff --unified=0 "$(git merge-base HEAD "$BASE_BRANCH")..HEAD" \
  | rg -n '^\+.*TODO'
```

## Classification First (Required)

Before asking implementation questions, classify each found item:

- `type`: `missing_impl` | `tech_debt` | `note_only` | `invalid_or_obsolete`
- `risk`: `high` | `medium` | `low`
- `recommended_path`: `fix_now` | `defer_with_tracker`

Do not skip classification.

## Human Discussion Loop

After classification, discuss each unresolved item with the human operator.

For each item, clarify:

- Intended behavior or missing implementation detail
- Whether this PR should implement now
- If deferred: tracker kind (issue or spec) and tracker number

Important: This skill is conversational. Do not jump directly to a final static report when open decisions remain.

## Resolution Rules

### Fix now

- Implement the change.
- Add/update tests when appropriate.
- Remove the marker, or replace with a regular explanatory comment that does not use TODO.

### Defer with tracker

- Rewrite the marker to exact tracked TODO syntax:
  - `TODO()` for issue-based follow-up
  - `TODO(spec)` for spec-based follow-up

- Keep concise context text after the tracked marker if needed.

Examples:

- `// TODO(): align archived filter behavior with list page`
- `// TODO(spec): move this editor flow into shared widget`

## Strict Validation

A deferred TODO is valid only if it matches one of:

- `TODO\(#\d+\)`
- `TODO\(spec#\d+\)`

These are invalid and blocking:

- Bare `TODO: ...`
- `TODO(123)`
- `TODO(issue)`
- `TODO(spec-123)`

## Completion Checklist

1. No unresolved TODO markers from branch-introduced diff.
2. Every deferred item uses exact tracked format.
3. Relevant checks/tests pass for touched code.
4. Conversation has no pending unresolved TODO decisions.

When all are satisfied, provide a brief closure confirmation.
