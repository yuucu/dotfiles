---
name: herdr
description: Control herdr from inside it. Manage workspaces and tabs, split panes, spawn agents, read output, and wait for state changes — all via CLI commands that talk to the running herdr instance over a local unix socket. Use when running inside herdr (HERDR_ENV=1).
---

# herdr — agent skill

**name:** herdr

**description:** "Control herdr from inside it. Manage workspaces and tabs, split panes, spawn agents, read output, and wait for state changes — all via CLI commands that talk to the running herdr instance over a local unix socket. Use when running inside herdr (HERDR_ENV=1)."

---

## Prerequisites

Before using this skill, verify that `HERDR_ENV=1`. If unset, you are not running inside a herdr-managed pane and should stop. Do not inspect or control the focused herdr pane from outside herdr.

## Overview

You are running inside herdr, a terminal-native agent multiplexer. herdr provides workspaces, tabs, and panes—each pane is a real terminal with its own shell, agent, server, or log stream—all controllable via CLI.

Capabilities include:
- Observing what other panes and agents are doing
- Creating tabs for separate subcontexts within one workspace
- Splitting panes and running commands in them
- Starting servers, watching logs, and running tests in sibling panes
- Waiting for specific output before continuing
- Waiting for another agent to finish
- Spawning additional agent instances

The `herdr` binary is available in your PATH. Its workspace, tab, pane, and wait commands communicate with the running herdr instance over a local unix socket.

For the raw protocol or full API reference, consult the [socket api docs](https://herdr.dev/docs/socket-api/).

## Concepts

**Workspaces:** Project contexts. Each workspace contains one or more tabs. Unless manually renamed, a workspace's label reflects the first tab's root pane—typically the repo name or root pane's current folder name.

**Tabs:** Subcontexts inside a workspace. Each tab contains one or more panes.

**Panes:** Terminal splits inside a tab. Each pane runs its own process—a shell, an agent, a server, or anything else.

**Agent Status:** Automatically detected by herdr. The API exposes:
- `agent_status` — `idle`, `working`, `blocked`, `done`, `unknown`

`done` means the agent finished but you have not yet viewed that finished pane.

Plain shells exist as panes, but herdr's sidebar intentionally focuses on detected agents rather than listing every shell.

**IDs:** Workspace IDs resemble `1`, `2`. Tab IDs resemble `1:1`, `1:2`, `2:1`. Pane IDs resemble `1-1`, `1-2`, `2-1`. These are compact public IDs for the current live session.

**Important:** IDs compact when tabs, panes, or workspaces are closed. Do not treat them as durable IDs. Re-read IDs from `workspace list`, `tab list`, `pane list`, or create/split responses when needed. Do not assume an older `1-3` is still the same pane later.

## Discover Yourself

See what panes exist and which one is focused:

```bash
herdr pane list
```

The focused pane is yours. Other panes are neighbors.

List workspaces:

```bash
herdr workspace list
```

## Tab Management

List tabs in the current workspace:

```bash
herdr tab list --workspace 1
```

Create a new tab:

```bash
herdr tab create --workspace 1
```

Without `--label`, the new tab keeps the default numbered name.

Create and name in one step:

```bash
herdr tab create --workspace 1 --label "logs"
```

Rename it:

```bash
herdr tab rename 1:2 "logs"
```

Focus it:

```bash
herdr tab focus 1:2
```

Close it:

```bash
herdr tab close 1:2
```

## Read Another Pane

See what is on another pane's screen:

```bash
herdr pane read 1-1 --source recent --lines 50
```

- `--source visible` = current viewport
- `--source recent` = recent scrollback as rendered in the pane
- `--source recent-unwrapped` = recent terminal text with soft wraps joined back together

## Split a Pane and Run a Command

Split your pane to the right and keep focus on your current pane:

```bash
herdr pane split 1-2 --direction right --no-focus
```

This prints JSON with the new pane at `result.pane.pane_id`. Parse that value, then run a command in that pane:

```bash
NEW_PANE=$(herdr pane split 1-2 --direction right --no-focus | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
herdr pane run "$NEW_PANE" "npm run dev"
```

Split downward instead:

```bash
herdr pane split 1-2 --direction down --no-focus
```

## Wait for Output

Block until specific text appears in a pane. Useful for waiting on servers, builds, and tests.

For `--source recent`, matching uses unwrapped recent terminal text, so pane width and soft wrapping do not break matches. `pane read --source recent` still shows the pane as rendered. To inspect the same transcript the waiter matches, use `pane read --source recent-unwrapped`.

```bash
herdr wait output 1-3 --match "ready on port 3000" --timeout 30000
```

With regex:

```bash
herdr wait output 1-3 --match "server.*ready" --regex --timeout 30000
```

If it times out, exit code is `1`.

## Wait for an Agent Status

Block until another agent reaches a specific status:

```bash
herdr wait agent-status 1-1 --status done --timeout 60000
```

Use this when you want the same `done` / `idle` distinction the UI shows.

## Send Text or Keys to a Pane

Send text without pressing Enter:

```bash
herdr pane send-text 1-1 "hello from claude"
```

Press Enter or other keys:

```bash
herdr pane send-keys 1-1 Enter
```

`pane run` sends the text and then a real `Enter` key in one request:

```bash
herdr pane run 1-1 "echo hello"
```

## Workspace Management

Create a new workspace:

```bash
herdr workspace create --cwd /path/to/project
```

Without `--label`, the new workspace keeps the default cwd-based name.

Create and name in one step:

```bash
herdr workspace create --cwd /path/to/project --label "api server"
```

Create without focusing it:

```bash
herdr workspace create --no-focus
```

Focus a workspace:

```bash
herdr workspace focus 2
```

Rename:

```bash
herdr workspace rename 1 "api server"
```

Close:

```bash
herdr workspace close 2
```

## Close a Pane

```bash
herdr pane close 1-3
```

## Recipes

### Run a server and wait until it is ready

```bash
NEW_PANE=$(herdr pane split 1-2 --direction right --no-focus | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
herdr pane run "$NEW_PANE" "npm run dev"
herdr wait output "$NEW_PANE" --match "ready" --timeout 30000
herdr pane read "$NEW_PANE" --source recent --lines 20
```

### Run tests in a separate pane and inspect the result

```bash
herdr pane split 1-2 --direction down --no-focus
herdr pane run 1-3 "cargo test"
herdr wait output 1-3 --match "test result" --timeout 60000
herdr pane read 1-3 --source recent --lines 30
```

### Check what another agent is working on

```bash
herdr pane list
herdr pane read 1-1 --source recent --lines 80
```

### Watch another pane robustly

Use this pattern when coordinating with a sibling pane:

```bash
# inspect what is already there
herdr pane read 1-3 --source recent --lines 40

# wait only for the next output you expect
herdr wait output 1-3 --match "ready" --timeout 30000

# if you need to inspect the same transcript the waiter matched,
# read the unwrapped recent text directly
herdr pane read 1-3 --source recent-unwrapped --lines 40
```

### Spawn a new agent and give it a task

```bash
herdr pane split 1-2 --direction right --no-focus
herdr pane run 1-3 "claude"
herdr wait output 1-3 --match ">" --timeout 15000
herdr pane run 1-3 "review the test coverage in src/api/"
```

### Coordinate with another agent

```bash
herdr wait agent-status 1-1 --status done --timeout 120000
herdr pane read 1-1 --source recent --lines 100
```

## Notes

- `workspace list`, `workspace create`, `tab list`, `tab create`, `tab get`, `tab focus`, `tab rename`, `tab close`, `pane list`, `pane get`, `pane split`, `wait output`, and `wait agent-status` print JSON on success.
- `pane read` prints text, not JSON.
- `pane read --format ansi` or `pane read --ansi` returns a rendered ANSI snapshot for TUI feedback loops.
- `pane read --source recent-unwrapped` is useful when you want to inspect the same unwrapped transcript that `wait output --source recent` matches against.
- `pane send-text`, `pane send-keys`, and `pane run` print nothing on success.
- Parse IDs from `workspace create`, `tab create`, and `pane split` responses when you need new IDs. `workspace create` returns `result.workspace`, `result.tab`, and `result.root_pane`. `tab create` returns `result.tab` and `result.root_pane`. For `pane split`, the new pane ID is at `result.pane.pane_id`.
- Use `pane read` for current output that already exists. Use `wait output` for future output you expect next.
- `--no-focus` on split, tab create, and workspace create keeps your current terminal context focused.
- Without `--label`, workspace create keeps cwd-based naming and tab create keeps numbered naming.
- `--label` on tab create and workspace create applies the custom name immediately.
- If you are running inside herdr, the `HERDR_ENV` environment variable is set to `1`.
