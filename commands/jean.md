---
description: Coding conventions and compounding project wiki — init, capture, lint, ingest
---

# jean

You are executing the `/jean` command. Your job is to set up this project for disciplined LLM-assisted development. Two things happen: coding conventions get injected into CLAUDE.md to counteract common LLM failure modes (wrong assumptions, overcomplication, sycophancy, drive-by edits), and a persistent wiki gets built that compounds project knowledge across sessions instead of rediscovering it from scratch every time.

**Arguments:** $ARGUMENTS

## Safety

These rules are non-negotiable:

- NEVER modify source code, tests, configs, or any file outside `.wiki/` and `CLAUDE.md`
- ALWAYS show the user exactly what you plan to create or change and get explicit confirmation before writing
- ALWAYS ask before modifying CLAUDE.md — show the exact text you will add
- If the wiki already exists, NEVER overwrite pages without showing what changed
- Treat the entire codebase as read-only except `.wiki/` and `CLAUDE.md`

## Mode Detection

Check whether `.wiki/` exists, then parse arguments:

| Arguments | Wiki exists? | Mode |
|---|---|---|
| *(empty)* | No | **init** — set up the wiki |
| *(empty)* | Yes | **capture** — save session artifacts |
| `init` | Either | **init** — set up (or re-initialize with confirmation) |
| `capture` | Yes | **capture** — save session artifacts |
| `lint` | Yes | **lint** — health-check the wiki |
| `ingest <path>` | Yes | **ingest** — process a source document |
| `status` | Yes | **status** — show wiki overview |

If the wiki doesn't exist and the user tries a mode other than init, tell them to run `/wiki init` first.

---

## Init Mode

Interactive setup. Never rush this — the questionnaire prevents harmful assumptions.

### Step 1: Understand the Project

Scan the project silently first, then present your understanding and ask the user to confirm or correct. Adapt to what exists:

**For existing projects:**
- Read README, manifest files (package.json, go.mod, Cargo.toml, pyproject.toml, etc.)
- Read existing CLAUDE.md if present
- Look at directory structure (top 2 levels)
- Scan docs/ or similar documentation directories
- Check if it's a git repo

Present: "Here's what I understand about this project: [summary]. Is this right? What should I correct?"

**For empty/new projects:**
- Ask: What will this project be? What stack? What's the goal?
- Ask: Any existing documentation or context you want to feed in?

### Step 2: Configure the Wiki

Ask the user about preferences. Suggest sensible defaults and let them adjust:

1. **What should the wiki track?** Present a checklist based on project type:
   - Architecture decisions and rationale
   - Component/module overviews
   - Patterns and idioms specific to this codebase
   - Bug patterns and gotchas
   - Session learnings and retrospectives
   - API surface documentation (if applicable)
   - Performance considerations (if applicable)
   - Additional categories based on what you see in the project

2. **Where should the wiki live?** Default: `.wiki/`

3. **Commit to git?** Default: yes — it's project knowledge worth sharing

4. **Modify CLAUDE.md?** Show the exact text you will add. Get explicit yes/no.

### Step 3: Create Wiki Structure

After the user confirms the full plan, create:

```
.wiki/
  index.md       — catalog of all pages with links and one-line summaries
  log.md         — append-only chronological activity log
  schema.md      — conventions for this specific wiki (generated from questionnaire)
  overview.md    — project overview and synthesis
  entities/      — components, modules, services, key subsystems
  concepts/      — architecture patterns, design principles, recurring themes
  decisions/     — architecture decision records (ADRs)
  sessions/      — session capture pages
  sources/       — summaries of processed documentation
```

Generate `schema.md` reflecting the user's answers: what page types exist, what goes where, naming rules, how to cross-reference. This file is what future sessions read to understand wiki conventions — make it clear and specific to this project.

### Step 4: Process Existing Documentation

For existing projects, read docs and synthesize into wiki pages:
- README becomes an enhanced `overview.md`
- Each significant doc gets a summary in `sources/` and updates to relevant entity/concept pages
- Major code components get entity pages based on code structure and comments
- A single source might touch 5-10 wiki pages — that's the point

Don't over-generate. Focus on major components and key documentation. The wiki grows over time; it doesn't need to be comprehensive on day one.

For empty projects, create just the scaffolding: `overview.md` with the project's stated goals, `schema.md`, empty `index.md` and `log.md`.

### Step 5: Inject into CLAUDE.md

Add a concise wiki section to CLAUDE.md. Create the file if it doesn't exist. The injection should contain ONLY what future sessions need to know — point to `schema.md` for details rather than duplicating conventions.

Template (adapt to this project's specifics):

```
## Coding Conventions

- Verify assumptions before acting. If something is unclear about the codebase, read the code or ask — don't guess and run with it.
- Surface confusion. If requirements are inconsistent or ambiguous, say so rather than silently picking an interpretation.
- Present tradeoffs. When multiple approaches exist, lay out the options before committing to one.
- Push back when appropriate. If a request would lead to worse code, say so with reasoning.
- Prefer the simplest solution. If you're writing 500+ lines, stop and ask whether there's a 50-line approach.
- Clean up after yourself. Remove dead code, unused imports, and obsolete comments introduced by your changes.
- Don't touch what you weren't asked to touch. No drive-by refactors, no removing comments you find unnecessary, no changes orthogonal to the task.
- Write tests first when the task is well-defined. Define success criteria, make them verifiable, then implement.

## Wiki

This project has an LLM-maintained knowledge base at `.wiki/`.

- Before starting work, read `.wiki/index.md` for accumulated project context
- Read `.wiki/schema.md` for wiki conventions
- When you discover something noteworthy (architecture insight, bug pattern, design decision), update relevant wiki pages
- When creating new pages, add them to `.wiki/index.md`
- After wiki changes, append an entry to `.wiki/log.md`
- Use [[wikilinks]] for cross-references between wiki pages
```

### Step 6: Report

Tell the user what was created: page count, what was processed, structure overview. Suggest natural next steps (e.g., "try `/wiki ingest path/to/doc.md` to process more documentation" or "after your next coding session, run `/wiki capture` to save what you learned").

---

## Capture Mode

Extract valuable knowledge from the current session before the context is cleared. This is the most common repeated operation — the user has just finished work (ideally after pushing) and wants to preserve what matters.

### Step 1: Assess the Session

Build a picture of what happened:
- If git repo: read `git log --oneline -20` and `git diff --stat` for recent activity
- Read `.wiki/log.md` for the last few entries (what was the wiki state before this session?)
- Note any wiki pages that might be affected by the session's changes

Present a brief summary: "Here's what I see from this session: [summary of changes/activity]."

### Step 2: Identify Artifacts

Analyze the session and categorize what you find. Present these to the user:

**Positive — what to replicate:**
- Decisions: architecture or design choices made, and their rationale
- Discoveries: new understanding about how the codebase or system works
- Patterns: approaches or idioms that worked well and are worth reusing

**Negative — what to avoid:**
- Gotchas: pitfalls, surprising behaviors, things that broke unexpectedly
- Tech debt: issues noticed but not addressed in this session
- Anti-patterns: approaches that were tried and failed, and why

**Context — why, not what:**
- Rationale for changes that future readers won't get from the diff alone
- Trade-offs considered but not documented in code comments

### Step 3: Curate with User

Present the artifacts and ask:
- Which of these should be saved to the wiki?
- Did I miss anything important?
- Any corrections to my summaries?

This is a conversation. Let the user add, remove, and edit. Don't file anything the user hasn't approved.

### Step 4: File into Wiki

For each approved artifact:
- Decisions go to `.wiki/decisions/YYYY-MM-DD-slug.md`
- Discoveries and patterns update existing entity/concept pages or create new ones
- Gotchas get added to relevant entity pages (or a dedicated gotchas section)
- Tech debt updates `.wiki/tech-debt.md` (create if it doesn't exist)
- Context gets added as sections in relevant pages

Create a session log page: `.wiki/sessions/YYYY-MM-DD-summary.md` that briefly describes the session and links to everything that was filed or updated.

Update `.wiki/index.md` with any new pages. Append to `.wiki/log.md`.

### Step 5: Report

Summarize what was saved: pages created, pages updated, artifacts filed. Quick and clean.

---

## Lint Mode

Health-check the wiki. Read all pages, then check for:

- **Dead links**: `[[wikilinks]]` pointing to pages that don't exist
- **Orphan pages**: pages not linked from index or any other page
- **Stale content**: wiki pages referencing code, files, or APIs that no longer exist (verify with Glob/Grep)
- **Missing pages**: important topics mentioned across pages but lacking their own page
- **Thin pages**: pages with very little content that could be expanded
- **Contradictions**: conflicting claims in different pages
- **Missing frontmatter**: pages without proper YAML frontmatter

Present findings grouped by severity. Offer to fix each category, but get confirmation before writing anything.

---

## Ingest Mode

Process a specific source document into the wiki.

1. Read the source at the given path
2. Summarize the key information and discuss with the user — what's important, what connects to existing wiki content?
3. Create a source summary page in `.wiki/sources/`
4. Update relevant entity and concept pages across the wiki — this is where the compounding happens
5. Update `.wiki/index.md` and append to `.wiki/log.md`

A single source might touch many wiki pages. That's the whole point.

---

## Status Mode

Quick wiki overview:
1. Read `.wiki/index.md` — report page count by category
2. Read last 5 entries from `.wiki/log.md` — show recent activity
3. Quick health: any obvious issues (dead links, orphans)?
4. Suggest next action based on state

---

## Page Conventions

### Frontmatter

Every wiki page starts with YAML frontmatter:

```yaml
---
title: Page Title
type: entity | concept | decision | session | source
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [relevant, tags]
---
```

### File Naming

- Lowercase, hyphens, no spaces: `auth-middleware.md`
- Decisions: `YYYY-MM-DD-decision-name.md`
- Sessions: `YYYY-MM-DD-session-summary.md`
- Sources: named after the source: `api-design-guide.md`

### Cross-references

- Between wiki pages: `[[page-name]]` (Obsidian-compatible wikilinks)
- To source code: relative paths with line numbers — `src/auth/middleware.ts:42`
- To sources: `[Source: Title](../sources/source-name.md)`

### Index Format

`.wiki/index.md` is organized by section. Each entry is one line:
```
- [[page-name]] — one-line description
```

Sections: Overview, Entities, Concepts, Decisions, Sessions, Sources, and any project-specific categories from the schema.

### Log Format

`.wiki/log.md` is append-only. Each entry:
```
## [YYYY-MM-DD] action | description

Brief details of what changed and why.
```

Actions: `init`, `ingest`, `capture`, `lint`, `update`
