# 🚀 Odoo Development Manager

<p align="center">
  <img src="https://img.shields.io/badge/version-3.0-blue?style=for-the-badge" alt="Version" />
  <img src="https://img.shields.io/badge/platform-Linux%20(Debian%2FUbuntu)-lightgrey?style=for-the-badge&logo=linux" alt="Platform" />
  <img src="https://img.shields.io/badge/shell-Bash-4EAA25?style=for-the-badge&logo=gnu-bash" alt="Bash" />
  <img src="https://img.shields.io/badge/license-Commercial-orange?style=for-the-badge" alt="License" />
</p>

<p align="center">
A professional command-line tool to create, run, and manage multiple Odoo<br/>
development environments — from a fresh install to a running server in minutes.
</p>

---

## What is this?

**Odoo Development Manager** is a single CLI tool (`odoo-manager`) that takes
care of everything an Odoo developer normally does by hand: cloning Odoo,
creating a Python virtual environment, generating `odoo.conf`, managing
projects and modules, starting/stopping the server, backups, database
management, and even installing the tools you need (VS Code, Cursor,
PyCharm, Git, PostgreSQL, etc.) — all from one guided menu.

You don't need to already have Odoo, Git, Python, or PostgreSQL installed.
The tool detects what's missing and can install it for you.

---

## 📚 Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [License Activation](#license-activation)
- [Quick Start](#quick-start)
- [Features](#-features)
- [Interactive Menu Walkthrough](#interactive-menu-walkthrough)
- [Non-Interactive CLI Mode](#non-interactive-cli-mode-scripting--automation)
- [Shell Tab-Completion](#shell-tab-completion)
- [Multi-Instance Support](#multi-instance-support)
- [Log Rotation](#log-rotation)
- [Environment Variables](#environment-variables)
- [Updating](#updating)
- [Uninstalling](#uninstalling)
- [Troubleshooting / FAQ](#troubleshooting--faq)
- [Support](#support)

---

## Requirements

- **Linux only** (Debian / Ubuntu — installer uses `apt-get`)
- `bash`, `curl`, `tar`, `openssl` (needed just to run the installer itself)

That's it. Everything else — **Git, Python 3, pip, PostgreSQL, build tools**
— is checked automatically on first run and can be installed for you with
one confirmation (`sudo` password will be requested when needed).

---

## Installation

Run this single command in your terminal:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/NisarZaidi/odoo-manager-releases/main/install.sh)
```

> ⚠️ Use `bash <(curl ...)` exactly as shown — **not** `curl ... | bash`.
> The installer asks for your license key interactively, and piping into
> `bash` steals your terminal's input, so the prompt would never be
> readable. `bash <(curl ...)` keeps your keyboard input working normally.

The installer will:

1. Check for `curl`, `tar`, `openssl` on your system
2. Download the latest release
3. Ask for your **license key** (see below)
4. Check/install system requirements (Git, Python 3, pip, PostgreSQL, etc.)
5. Install `odoo-manager` to `~/.local/bin` and add it to your `PATH`
6. Set up Bash/Zsh tab-completion

Once it finishes, just run:

```bash
odoo-manager
```

---

## License Activation

Odoo Development Manager is licensed software. When you purchase it, you
receive a single **license key** (a long string) directly from the seller
by email or WhatsApp — no account, no file, nothing else needed.

- The very first time you run the installer (or `odoo-manager` itself), you
  will be prompted to paste that key.
- The key is verified **entirely offline** — no internet/license server
  required — and cached at `~/.odoo-manager-license` so you're never asked
  again on that machine.
- Lost your key or need a new one? Contact the seller (see
  [Support](#support)) — they can look it up or reissue it for you.

---

## Quick Start

```bash
odoo-manager
```

That's it — the interactive wizard takes over from here:

1. **First run, no workspaces found** → guided wizard: pick an Odoo version
   (13–19), it clones Odoo Community, creates a Python virtual environment,
   installs dependencies, and generates a working `odoo.conf`.
2. **Create a project** → use **Project Generator** to scaffold a new
   project folder, optionally as a git repo, optionally with a first module
   already scaffolded.
3. **Start Odoo** → one keypress. Your browser-ready Odoo instance is
   running on its own dedicated port.

---

## ✨ Features

| Category | What it does |
|---|---|
| **Setup** | Guided workspace wizard — clones Odoo, creates a venv, generates `odoo.conf`, all automatically |
| **Multi-Version** | Run Odoo 13 through 19 side by side, each on its own HTTP/longpolling port |
| **Projects** | Project Generator (folder + optional git init + optional first module), per-project module list, Git status/branch/dirty-count badges |
| **Server Control** | Start / Stop / Restart Odoo with a reliable readiness check (not a blind timer) |
| **Modules** | Scaffold new modules (`odoo-bin scaffold`), upgrade modules against any database |
| **Database** | Create, duplicate, backup, restore, and drop PostgreSQL databases from the menu |
| **Backups** | Full workspace backup/restore (`custom_addons`, `enterprise`, `projects`, `odoo.conf`) |
| **Git Integration** | Per-project branch/status badges, pull, log, commit & push, all without leaving the tool |
| **Editors** | Open a whole project — or a single module — directly in **VS Code**, **Cursor**, or **PyCharm** |
| **Tool Installer** | Missing VS Code / Cursor / PyCharm? Install them from the tool itself, no browser needed |
| **System Requirements** | Missing Git / Python 3 / pip / PostgreSQL / openssl / build tools? Install them from the tool itself |
| **Diagnostics** | Workspace Doctor — health check + auto-repair for broken/missing folders and config |
| **Logs** | Live log viewer, automatic log rotation (configurable size/backup count) |
| **Automation** | Full non-interactive CLI mode for scripts, cron jobs, and CI |
| **Distribution** | One-line installer, global `odoo-manager` command, Bash + Zsh tab-completion |
| **Updates** | Checks for a newer version on every launch (silent, non-blocking, skippable) |

---

## Interactive Menu Walkthrough

```
╔════════════════════════════════════════════════════════════════════╗
║                      ODOO DEVELOPMENT MANAGER                      ║
║                            Version 3.0                             ║
╚════════════════════════════════════════════════════════════════════╝
  Workspace   /home/you/Documents
  Found       2 workspace(s)
  ...
──────────────────────────────────────────────
  Available Odoo Versions
  1) odoo18     ● Running
  2) odoo17     ○ Stopped
──────────────────────────────────────────────
 ▶ Workspace Actions
   N) Create New Workspace
   R) Refresh
 ▶ Setup Tools
   I) Install Development Tools (VS Code / Cursor / PyCharm)
   Y) Install System Requirements (Git / Python / pip / PostgreSQL / openssl)
 ▶ Navigation
   Q) Quit
```

Type a **number** to open a workspace and pick a project, or a **letter**
to run that action directly. Every screen in the tool follows this same
pattern.

---

## Non-Interactive CLI Mode (scripting / automation)

Every core action is also available as a direct command — perfect for
scripts, cron jobs, or CI pipelines:

```bash
odoo-manager start   --workspace odoo18 --project agri
odoo-manager stop    --workspace odoo18
odoo-manager restart --workspace odoo18 --project agri
odoo-manager status                       # every workspace
odoo-manager status  --workspace odoo18   # one workspace
odoo-manager list                         # list all workspaces
odoo-manager check-db-connection          # test PostgreSQL connectivity
odoo-manager --auto-update                # launch + auto git-pull updates
odoo-manager --version
odoo-manager --help
```

---

## Shell Tab-Completion

Installed automatically for both Bash and Zsh. Just start typing and
press `<TAB>`:

```bash
odoo-manager sta<TAB>          # -> start
odoo-manager start --workspace <TAB>   # -> lists your real workspaces
odoo-manager start --workspace odoo18 --project <TAB>   # -> lists real projects
```

---

## Multi-Instance Support

Every workspace gets its own HTTP and longpolling port, calculated from
its Odoo version, so `odoo17`, `odoo18`, and `odoo19` can all run **at the
same time** without clashing:

| Odoo Version | HTTP Port | Longpolling Port |
|---|---|---|
| 17 | 8239 | 8242 |
| 18 | 8249 | 8252 |
| 19 | 8259 | 8262 |

If a port is already taken by something else, **Start Odoo** refuses to
start and tells you exactly which port is busy instead of failing
silently. Quitting the manager (`Q` or `Ctrl+C`) stops **every** running
Odoo instance across every workspace, so nothing is left running in the
background after you exit.

---

## Log Rotation

`odoo.log` is rotated automatically once it crosses a size limit. Defaults:
**20 MB per file, 5 backups kept**. Override with environment variables:

```bash
LOG_MAX_SIZE_MB=50 LOG_MAX_BACKUPS=10 odoo-manager
```

---

## Environment Variables

| Variable | Purpose | Default |
|---|---|---|
| `ODOO_MANAGER_WORKSPACE_ROOT` | Where workspaces are created/detected | `$HOME/Documents` |
| `ODOO_MANAGER_SKIP_UPDATE_CHECK` | Set to `1` to skip the startup update check | unset |
| `ODOO_MANAGER_AUTO_UPDATE` | Set to `1` to auto git-pull updates on startup | unset |
| `LOG_MAX_SIZE_MB` | Log rotation size threshold | `20` |
| `LOG_MAX_BACKUPS` | Log rotation backups kept | `5` |

---

## Updating

```bash
odoo-manager --auto-update
```

Or, if you prefer to be asked first, just launch `odoo-manager` normally —
it checks for a newer version on every startup and will prompt you if one
is available.

---

## Uninstalling

An uninstaller is saved automatically during installation:

```bash
~/.local/share/odoo-manager/uninstall.sh
```

This removes the `odoo-manager` command, your `PATH` entry, and shell
tab-completion. **Your workspaces, projects, databases, and saved license
key are never touched.**

---

## Troubleshooting / FAQ

**"Invalid license key" during install**
Double-check you copied the *entire* key with no extra spaces or line
breaks. If it still fails after 3 attempts, contact the seller.

**A required package failed to install automatically**
Automatic installs only support `apt-get` (Debian/Ubuntu). On other
distros, install the listed package manually and re-run.

**Port already in use**
Another process (or another Odoo instance) is already bound to that
workspace's port. Stop it, or change `http_port` in that workspace's
`odoo.conf` from the **Configuration** menu.

**Odoo won't start / crashes immediately**
Check the log file shown on screen (`.../logs/odoo.log`) — it usually
points straight to a bad addon or a missing Python dependency. **Workspace
Doctor** (`H` from the Development Menu) can also auto-repair common
structural issues (missing folders, missing `odoo.conf`).

---

## Support

For license issues, reinstalling on a new machine, or general questions,
contact the seller directly with the email/contact you used at purchase.
Please include your license key (or the name/email used to buy it) so it
can be looked up quickly.

For bugs or feature requests, please open a
[GitHub Issue](https://github.com/NisarZaidi/odoo-manager-releases/issues)
in this repository.

---

Thank you for using **Odoo Development Manager** — happy building! 🚀
