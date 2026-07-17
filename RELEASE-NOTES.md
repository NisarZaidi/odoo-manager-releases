# Odoo Manager v2.1.0

Odoo Manager is an all-in-one command-line toolkit designed to simplify and
automate Odoo development on Ubuntu. Whether you're setting up a new
workstation or managing multiple Odoo environments, it provides a fast,
consistent, and reliable workflow from installation to daily development.

Built for Odoo developers, freelancers, and teams — Odoo Manager minimizes
manual configuration, reduces setup time, and helps you focus on development
instead of environment management.

---

## ✨ What's New in v2.1.0

### 🎯 Smarter Menu Organization
- Tools distributed across 3 screens based on context:
  - **Global Tools** (Workspace screen): Batch Ops, Templates, Remote, Aliases
  - **Project Tools** (Project screen): Time Tracker, Metadata, Team Sync
  - **Advanced Tools** (Dev Menu): Scaffold, Deps, Quality, Migration, DB Compare, Multi-DB Test
- All special character keys (`@`, `#`, `$`, etc.) replaced with simple letters
- Hot Reload now accessible via **S → 2** (Start Odoo submenu)

### 🔥 15 New Advanced Developer Tools

- **Hot Reload** — auto-restart Odoo when code files change (uses `inotify-tools`)
- **Advanced Module Scaffold** — create production-ready modules with full boilerplate (models, views, security, wizards, controllers)
- **Module Dependency Graph** — visualize dependencies between modules, detect circular deps
- **Module Quality Checker** — score modules 0–10 with common issue detection
- **Batch Operations** — start/stop/backup ALL workspaces at once
- **Environment Templates** — save and restore workspace configurations as reusable templates
- **Per-Project Time Tracker** — track hours per project with CSV export for invoicing
- **Client/Project Metadata** — store client name, description, deadline per project
- **Custom Command Aliases** — define your own shortcut commands
- **Team Sync** — export/import workspace config as JSON for team sharing via git
- **Remote Server Management** — control remote Odoo instances via SSH (start/stop/restart/logs)
- **DB Migration Helper** — compatibility check for version upgrades with deprecation detection
- **DB Snapshot & Compare** — take schema snapshots and diff between databases
- **Multi-Database Testing** — test module upgrades against multiple databases
- **Desktop Notifications** — alerts for start/stop/crash/backup events

---

## ✨ Features

### 🔐 Secure Licensing
- RSA-signed license keys verified entirely offline
- No internet or license server required for activation
- Lifetime keys — one-time purchase, no subscription
- Integrated licensing during installation
- License management utilities built-in

### 🚀 Automated Development Environment
- Automatic system dependency installation (Git, Python, pip, PostgreSQL, build tools)
- Automatic Python virtual environment creation (correct version per Odoo release)
- Automatic `requirements.txt` installation with smart retry and version ceilings
- Automatic workspace initialization with guided 7-step wizard
- Automatic Odoo Community clone (correct branch per version)
- Automatic `odoo.conf` generation with unique ports and addons paths
- Ready-to-use development environment with minimal manual setup

### 📂 Workspace & Project Management
- Automatic workspace detection (`odoo*` pattern)
- Interactive workspace selection with favorites and recents
- Interactive project selection with module counts and git badges
- Create and manage multiple Odoo workspaces side by side
- Built-in workspace backup and restore (tar.gz archives)
- Point-in-time snapshots with doctor report and optional DB dump
- Auto backup scheduler (cron-based with retention cleanup)
- Environment export/import for migrating between machines
- Organized project structure for long-term maintenance

### ⚙️ Odoo Management
- Supports Odoo 13, 14, 15, 16, 17, 18, and 19
- One-command Odoo server startup with reliable readiness check
- Multi-instance support — run multiple Odoo versions simultaneously
- Unique HTTP + longpolling ports per Odoo version (no clashes)
- Port conflict detection with clear error messages
- Automatic virtual environment detection and activation
- Automatic addons path generation (dynamic, cached, only real modules)
- Auto-shutdown of ALL running instances on quit (parallel stop)
- Project-specific configuration handling
- Simplified multi-version Odoo development

### 🗄 Database Management
- Full PostgreSQL database manager scoped to each workspace
- List, create, duplicate, backup, restore, and drop databases
- One-click DB Clone & Run (duplicate + restore + start Odoo)
- Pre-drop safety backup before dropping any database
- Simplified database operations for faster project switching

### 🧩 Module Management
- Scaffold new modules via `odoo-bin scaffold` from the menu
- Upgrade modules against any database with one keypress
- Manifest Inspector — view name, version, depends, data files
- Highlights potential issues (missing fields, broken dependencies)
- Enterprise auto-detection (modules in `enterprise/` folder)

### 🛠 Developer Tools
- One-click installer for **VS Code**, **Cursor**, and **PyCharm Community**
- Detect installed editors automatically with live status badges
- Install missing editors individually or all at once
- Open any Odoo project — or a specific module — directly in your preferred editor
- System requirements installer (Git, Python 3, pip, PostgreSQL, openssl, build-essential)

### 🔀 Git Integration
- Per-project branch/status badges (clean ✔ / dirty ●count)
- Commit & Push workflow (stage all or specific files)
- Smart Pull with auto-stash (prevents merge conflicts)
- Stash Push/Pop for saving work-in-progress
- Recent commit log viewer
- Initialize git repos for new projects

### 🧪 Test & Lint Runner
- Run tests via pytest, unittest, or Odoo test framework
- Lint checks with flake8 / pylint
- Auto-detects available test frameworks in the project venv
- Also accessible via CLI: `odoo-manager test` and `odoo-manager lint`

### 📊 Dashboard & Diagnostics
- Unified dashboard showing all workspaces at a glance
- Running/stopped status, port badges, health indicators
- Per-workspace project and module counts
- System resource check (CPU, memory, disk, PostgreSQL)
- **Workspace Doctor** — health check + auto-repair for common issues
- JSON output support for status, list, and doctor commands

### 📋 Productivity Features
- Bash and Zsh shell tab-completion (installed automatically)
- Non-interactive CLI mode for scripts, cron jobs, and CI
- Quick CLI aliases (`open`, `logs`, `shell`, `psql`, `test`, `lint`)
- Live log viewer with auto-rotation
- Interactive log search (grep/filter by term or log level)
- Shell shortcuts menu (Odoo shell, psql, venv, bash)
- Workspace and project notes (persistent across sessions)
- Config profiles (save/load named presets: dev, staging, prod)
- Secrets separation via `.env` file
- Plugin system for custom commands and menu items
- Update checker (checks GitHub on startup, silent on failure)

### 🚀 Advanced Tools (NEW in v2.1.0)
- Hot Reload with file watching (auto-restart on code changes)
- Advanced Module Scaffold (full boilerplate with models, views, security, wizards)
- Module Dependency Graph (tree output + circular dependency detection)
- Module Quality Checker (score 0–10 with issue detection)
- Batch Operations (start/stop/backup all workspaces)
- Environment Templates (save/restore workspace configs)
- Per-Project Time Tracker (start/stop/report/CSV export)
- Client/Project Metadata (client name, description, deadline tracking)
- Custom Command Aliases (user-defined shortcuts)
- Team Sync (export/import workspace config as JSON)
- Remote Server Management (SSH-based Odoo control)
- DB Migration Helper (compatibility check + migration checklist)
- DB Snapshot & Compare (schema diff between databases)
- Multi-Database Testing (test modules against multiple DBs)
- Desktop Notifications (alerts for important events)

---

## 💻 Non-Interactive CLI Mode

Every core action is also available as a direct command:

```bash
# Server Control
odoo-manager start   --workspace odoo18 --project agri
odoo-manager stop    --workspace odoo18
odoo-manager restart --workspace odoo18 --project agri
odoo-manager status                       # every workspace
odoo-manager status  --json              # machine-readable output
odoo-manager list                         # list all workspaces
odoo-manager doctor  --workspace odoo18 --json
odoo-manager check-db-connection          # test PostgreSQL connectivity

# Quick Shortcuts
odoo-manager open   --workspace odoo18 --project agri    # open in editor
odoo-manager logs   --workspace odoo18                   # tail -f odoo.log
odoo-manager shell  --workspace odoo18 --project agri    # Odoo shell
odoo-manager psql   --workspace odoo18 --db mydb         # PostgreSQL shell
odoo-manager test   --workspace odoo18 --project agri    # run tests
odoo-manager lint   --workspace odoo18 --project agri    # flake8/pylint

# Advanced Tools (NEW in v2.1.0)
odoo-manager scaffold  --workspace odoo18 --project agri  # advanced scaffold
odoo-manager quality   --workspace odoo18                 # quality checker
odoo-manager deps      --workspace odoo18                 # dependency graph
odoo-manager batch                                         # batch operations
odoo-manager templates                                     # env templates
odoo-manager timetrack                                     # time tracker
odoo-manager aliases                                       # custom aliases
odoo-manager remote                                        # remote servers
odoo-manager migration --workspace odoo18                  # migration helper
odoo-manager dbcompare --workspace odoo18                  # DB compare
odoo-manager multitest --workspace odoo18                  # multi-DB testing

odoo-manager --auto-update                # launch + auto git-pull updates
odoo-manager --help
```

---

## 🌐 Multi-Instance Ports

| Odoo Version | HTTP Port | Longpolling Port |
|---|---|---|
| 13 | 8199 | 8202 |
| 14 | 8209 | 8212 |
| 15 | 8219 | 8222 |
| 16 | 8229 | 8232 |
| 17 | 8239 | 8242 |
| 18 | 8249 | 8252 |
| 19 | 8259 | 8262 |

---

## ⚙️ System Requirements

- Ubuntu 22.04 LTS / 24.04 LTS (or any Debian-based Linux)
- `bash`, `curl`, `tar`, `openssl` (installer prerequisites)

No manual environment preparation required. Odoo Manager automatically
installs and configures all required development dependencies.

---

## 📦 Installation

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/NisarZaidi/odoo-manager-releases/main/install.sh)
```

> **Important:** Use `bash <(curl ...)` — **not** `curl ... | bash`.
> The installer prompts for your license key interactively.

---

## 🔄 Update

```bash
odoo-manager --auto-update
```

---

## 📦 Release Assets

| File | Description |
|---|---|
| `odoo-manager.tar.gz` | Main release package (bin + lib + completion) |
| `odoo-manager.tar.gz.sha256` | SHA-256 checksum for download verification |

---

## 📝 Notes

- Public repository contains only the installer and release packages
- The complete source code is maintained in a private repository
- Currently supported platform: Ubuntu Linux (Debian-based)
- Package installation is handled automatically using APT
- License keys are verified entirely offline (RSA-signed, no server required)
- Feature requests and bug reports are welcome through [GitHub Issues](https://github.com/NisarZaidi/odoo-manager-releases/issues)

---

## 📬 Support

| Channel | Contact |
|---|---|
| Email | nisarzaidi75@gmail.com |
| WhatsApp | +92-301-2122387 |
| Issues | [GitHub Issues](https://github.com/NisarZaidi/odoo-manager-releases/issues) |

---

Thank you for choosing **Odoo Manager** to power your Odoo development workflow.
