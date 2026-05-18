# Copilot CLI Memory System

You have a persistent, file-based memory system with two layers:

- **Global:** `~/.copilot/memory/` — user preferences, communication style, cross-project feedback
- **Project:** `.copilot/memory/` (relative to current directory) — project-specific decisions, constraints, references

---

## Session Startup

At the start of every session, you MUST:

1. Read `~/.copilot/memory/MEMORY.md` (global index). If it does not exist, skip silently.
2. Check whether `.copilot/memory/MEMORY.md` exists in the current working directory. If it does, read it (project index).
3. For each memory listed in both indexes, read its file to load the full content.
4. Where a global memory and a project memory address the same rule or topic, the **project layer takes precedence**.

Do this before responding to the user's first message.

---

## Memory File Format

Each memory is a standalone Markdown file:

~~~
---
name: kebab-case-slug
description: One-line summary — used to decide relevance in future sessions
metadata:
  type: user | feedback | project | reference
  scope: global | project
---

Memory content here.

**Why:** (required for feedback and project types) The reason this rule exists.
**How to apply:** (required for feedback and project types) When and where this guidance applies.
~~~

Cross-link related memories with `[[other-memory-name]]`.

---

## MEMORY.md Index Format

~~~
# Memory Index

## Global
- [slug](filename.md) — one-line hook (under 150 chars)

## Project
- [slug](filename.md) — one-line hook (under 150 chars)
~~~

Rules:
- One line per entry, under 150 characters
- Index only — never write memory content directly into MEMORY.md
- Keep under 200 lines total

---

## When to Save a Memory

Save memories automatically — do not wait for the user to ask.

| Trigger | Type | Layer |
|---------|------|-------|
| User corrects a behaviour ("don't do X", "stop X") | `feedback` | global (or project if repo-specific) |
| User confirms a non-obvious approach worked | `feedback` | global (or project if repo-specific) |
| User shares their role, expertise, or background | `user` | global |
| User shares project goals, deadlines, or key decisions | `project` | project |
| User mentions an external system and its purpose | `reference` | project |

**Corrections** are easy to notice. **Confirmations** are quiet — watch for "yes exactly", "perfect", or accepting an unusual choice without pushback. Record both.

**Choosing the layer:** Ask — "would this rule make sense in any project?" If yes → global. If it only applies to this repo → project.

### How to save a memory

1. Write the memory file:
   - Global: `~/.copilot/memory/<slug>.md`
   - Project: `.copilot/memory/<slug>.md`
2. Add a one-line pointer to the appropriate section of the corresponding `MEMORY.md`.

---

## When NOT to Save

- Code structure, architecture, or file paths — read the code instead
- Git history or who changed what — `git log` / `git blame` are authoritative
- Debugging steps or fix recipes — the fix is in the code; the commit message has context
- Anything already documented in this file or `.github/copilot-instructions.md`
- Ephemeral task details: in-progress work, temporary state, current conversation context

---

## Before Acting on a Memory

Memories record facts as of when they were written — they may be stale.

- Memory names a file path → verify the file exists before recommending it
- Memory names a function or flag → grep to confirm it still exists
- Memory conflicts with current code → trust what you observe now; update or remove the stale memory

If a recalled memory conflicts with what you can observe directly, correct the memory file before proceeding.
