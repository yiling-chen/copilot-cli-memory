# Copilot CLI Memory System

A persistent, file-based memory system for GitHub Copilot CLI, modelled after Claude Code's memory architecture.

Copilot CLI starts fresh every session. This system gives it long-term memory: it reads what it learned in past sessions and writes new memories automatically as it learns things about you and your projects.

---

## How It Works

- `~/.copilot/instructions.md` — injects memory behaviour rules into every Copilot CLI session
- `~/.copilot/memory/` — global memories (user preferences, cross-project feedback)
- `.copilot/memory/` (inside a repo) — project memories (decisions, constraints, references)

At the start of every session, Copilot CLI reads the memory indexes and loads all listed memory files. It writes new memories automatically when you correct it, confirm an approach, or share context about yourself or your project.

---

## Installation

### 1. Clone this repository

```bash
git clone <this-repo-url> ~/copilot-cli-memory
cd ~/copilot-cli-memory
```

### 2. Run the installer

```bash
./install.sh
```

This creates `~/.copilot/instructions.md` and `~/.copilot/memory/MEMORY.md`.

If `~/.copilot/instructions.md` already exists, the installer skips it. To add the memory rules to an existing file, manually append the contents of `instructions.md` from this repo.

### 3. (Optional) Initialise project-level memory

Inside any repo where you want project-scoped memories:

```bash
/path/to/copilot-cli-memory/init-project.sh
```

This creates `.copilot/memory/MEMORY.md` in the current directory.

To share memories with your team, commit `.copilot/memory/`. To keep them personal:

```bash
echo ".copilot/memory/" >> .gitignore
```

---

## Memory Types

| Type | Purpose | Default layer |
|------|---------|--------------|
| `user` | Your role, expertise, background | Global |
| `feedback` | How Copilot should behave (general) | Global |
| `feedback` | Repo-specific rules ("no DB mocks here") | Project |
| `project` | Decisions, deadlines, key context | Project |
| `reference` | Where to find things in external systems | Project |

---

## Memory File Format

```markdown
---
name: feedback-no-db-mock
description: Integration tests must hit real database, not mocks
metadata:
  type: feedback
  scope: project
---

Don't mock the database in tests.

**Why:** Prior incident where mock/prod divergence masked a broken migration.
**How to apply:** Any test touching data access must use a real DB connection.
```

---

## Day-to-Day Usage

You don't need to do anything. Copilot CLI reads and writes memories automatically.

**To see what's been remembered:**

```bash
cat ~/.copilot/memory/MEMORY.md          # global index
cat .copilot/memory/MEMORY.md            # project index (if initialised)
```

**To edit or delete a memory:** open the `.md` file directly and edit or delete it. Update `MEMORY.md` to remove the pointer if you delete a file.

**To force Copilot to remember something:** just tell it — "remember that we never mock the database in this repo." It will write the memory file immediately.

---

## Project-Layer Overrides Global

If a project memory and a global memory address the same rule, the project layer wins. This lets you tighten or override global defaults per repo — for example, a global "no confirmation needed before commit" can be overridden by a project-level "always confirm before committing."

When Copilot is uncertain which layer to use, it defaults to global. You can always ask it to move a memory to the project layer.

---

## Troubleshooting

**Copilot doesn't seem to remember things across sessions**
- Confirm `~/.copilot/instructions.md` exists and contains the memory rules
- Check `~/.copilot/memory/MEMORY.md` — is the memory listed there?
- Open the memory file directly and confirm it has content

**Copilot is acting on a stale memory**
- Open the memory file and correct or delete it
- Remove its line from `MEMORY.md` if deleting
- If correcting, Copilot will append a revision note with the date
