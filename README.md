# jean-claude-kar-pathy

A Claude Code plugin that sets up and maintains an LLM-powered knowledge base for any project. Based on Andrej Karpathy's [LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) pattern and his [observations on LLM-assisted coding](https://x.com/karpathy/status/2015883857489522876).

The core idea: instead of re-discovering project knowledge from scratch every session, the LLM **incrementally builds and maintains a persistent wiki** — a structured, interlinked collection of markdown files. Cross-references are pre-built, contradictions are flagged, session learnings compound over time. The wiki gets richer with every source you add and every session you capture.

The plugin also injects coding conventions into your project's `CLAUDE.md` — direct antidotes to common LLM failure modes (wrong assumptions, overcomplication, drive-by edits, sycophancy) drawn from real-world experience with agent-assisted development.

## Install

```bash
git clone https://github.com/user/jean-claude-kar-pathy.git
cd jean-claude-kar-pathy
./install.sh        # install globally — available in every project
```

Three install options:

| Command | Where | Available as |
|---|---|---|
| `./install.sh` | `~/.claude/commands/` | `/user:wiki` in any project |
| `./install.sh project` | `.claude/commands/` in cwd | `/project:wiki` in this project only |
| `./install.sh link` | symlink to `~/.claude/commands/` | `/user:wiki`, auto-updates from repo |

## Usage

One command, context-aware. It does the right thing based on whether a wiki already exists:

```
/wiki              # init if no wiki, capture if wiki exists
/wiki init         # set up the wiki (interactive)
/wiki capture      # save session artifacts before clearing context
/wiki lint         # health-check the wiki
/wiki ingest path  # process a document into the wiki
/wiki status       # overview of wiki state
```

### Init — set up the wiki

Run `/wiki` in any project. The plugin:

1. **Scans your project** — reads README, manifest files, directory structure, existing docs
2. **Asks you questions** — confirms its understanding, asks what to track, gets consent before touching anything
3. **Creates the wiki** — structured markdown files in `.wiki/`:
   ```
   .wiki/
     index.md       — catalog of all pages
     log.md         — chronological activity log
     schema.md      — conventions for this wiki
     overview.md    — project synthesis
     entities/      — components, modules, services
     concepts/      — patterns, principles, design philosophy
     decisions/     — architecture decision records
     sessions/      — session capture pages
     sources/       — documentation summaries
   ```
4. **Processes existing documentation** — README, docs, code structure get synthesized into interlinked wiki pages. A single source might touch 5-10 pages.
5. **Injects into CLAUDE.md** — adds coding conventions and wiki instructions so every future session is wiki-aware

For empty projects, it asks what you're building and creates the scaffolding.

### Capture — save session learnings

The most common repeated operation. After a coding session (ideally after pushing), run `/wiki capture` (or just `/wiki` — it defaults to capture when the wiki exists).

The plugin:

1. **Reviews the session** — checks git log, diffs, and recent activity
2. **Identifies artifacts**, categorized as:
   - **Positive** — decisions made, discoveries about the codebase, patterns that worked
   - **Negative** — gotchas, tech debt spotted, anti-patterns that failed
   - **Context** — rationale that future readers won't get from the diff
3. **Lets you curate** — pick what's worth saving, edit summaries, add what was missed
4. **Files into the wiki** — creates/updates pages, cross-references, index, and log

This is where the wiki compounds. Session knowledge that would normally vanish when you clear context gets preserved and interlinked.

### Lint — health-check

Run `/wiki lint` periodically. Checks for dead links, orphan pages, stale content that no longer matches the code, missing pages for frequently-mentioned topics, and contradictions between pages.

### Ingest — process a source

Run `/wiki ingest path/to/document.md` to process any document into the wiki. The plugin reads it, discusses key takeaways with you, creates a source summary, and updates entity/concept pages across the wiki.

## What gets injected into CLAUDE.md

Two sections. Coding conventions first, wiki instructions second:

```markdown
## Coding Conventions

- Verify assumptions before acting. If something is unclear about the
  codebase, read the code or ask — don't guess and run with it.
- Surface confusion. If requirements are inconsistent or ambiguous, say so
  rather than silently picking an interpretation.
- Present tradeoffs. When multiple approaches exist, lay out the options
  before committing to one.
- Push back when appropriate. If a request would lead to worse code, say so
  with reasoning.
- Prefer the simplest solution. If you're writing 500+ lines, stop and ask
  whether there's a 50-line approach.
- Clean up after yourself. Remove dead code, unused imports, and obsolete
  comments introduced by your changes.
- Don't touch what you weren't asked to touch. No drive-by refactors, no
  removing comments you find unnecessary, no changes orthogonal to the task.
- Write tests first when the task is well-defined. Define success criteria,
  make them verifiable, then implement.

## Wiki

This project has an LLM-maintained knowledge base at `.wiki/`.

- Before starting work, read `.wiki/index.md` for accumulated project context
- Read `.wiki/schema.md` for wiki conventions
- When you discover something noteworthy (architecture insight, bug pattern,
  design decision), update relevant wiki pages
- When creating new pages, add them to `.wiki/index.md`
- After wiki changes, append an entry to `.wiki/log.md`
- Use [[wikilinks]] for cross-references between wiki pages
```

The coding conventions are direct antidotes to the most common LLM agent failure modes: making assumptions without checking, overcomplicated solutions, silent interpretation of ambiguity, drive-by changes to unrelated code, and sycophantic agreement instead of pushback.

## Safety

The plugin treats your codebase as read-only. It will only ever modify:
- Files inside `.wiki/`
- `CLAUDE.md` (with explicit consent)

It shows you exactly what it plans to write and asks for confirmation before every change. If the wiki already exists, it won't overwrite pages without showing diffs.

## Design

Three layers, following the LLM Wiki pattern:

**Raw sources** — your codebase, documentation, and any documents you feed in. The plugin reads from these but never modifies them.

**The wiki** — `.wiki/` directory of LLM-generated markdown files. The plugin owns this layer entirely. It creates pages, maintains cross-references, flags contradictions, and keeps everything consistent.

**The schema** — `CLAUDE.md` injection + `.wiki/schema.md`. These tell future Claude Code sessions how the wiki works, what the conventions are, and how to maintain it. This is what makes the LLM a disciplined wiki maintainer rather than a generic chatbot.

## Recommended workflow

1. Install globally: `./install.sh`
2. In your project: `/wiki` to initialize
3. Code as usual with Claude Code
4. Before clearing context: `/wiki capture` to save what you learned
5. Periodically: `/wiki lint` to keep the wiki healthy
6. When you add docs: `/wiki ingest path/to/doc.md`

The wiki is just markdown files. It works with Obsidian (graph view is great for seeing connections), it's git-friendly, and it compounds over time.

## Compatibility

Works with any Claude Code environment — CLI, desktop app, web app, IDE extensions. The plugin is a single markdown file that becomes a slash command. No dependencies, no build step, no runtime.

## Credits

- **LLM Wiki pattern**: [Andrej Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- **Coding conventions**: Distilled from Karpathy's [notes on LLM-assisted coding](https://x.com/karpathy/status/2015883857489522876)
- **Implementation**: Built with Claude Code

## License

MIT
