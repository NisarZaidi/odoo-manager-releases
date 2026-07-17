# Odoo Development Manager — User Manual

<p align="center">
  <strong>Complete guide for Odoo Development Manager v2.1</strong>
</p>

---

## Table of Contents

- [Getting Started](#getting-started)
- [First Launch](#first-launch)
- [Interactive Menu Reference](#interactive-menu-reference)
  - [Odoo Management](#odoo-management)
  - [Module Management](#module-management)
  - [Database and Workspace](#database-and-workspace)
  - [Development Tools](#development-tools)
  - [Advanced Tools](#advanced-tools-1)
  - [Overview and Environment](#overview-and-environment)
  - [Navigation](#navigation)
- [CLI Command Reference](#cli-command-reference)
- [Workspace Management](#workspace-management)
- [Project Management](#project-management)
- [Module Development](#module-development)
- [Database Operations](#database-operations)
- [Backup and Restore](#backup-and-restore)
- [Advanced Tools Guide](#advanced-tools-guide)
- [Team Collaboration](#team-collaboration)
- [Remote Server Management](#remote-server-management)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

---

## Getting Started

### Installation

Run this single command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/NisarZaidi/odoo-manager-releases/main/install.sh)
```

The installer will:
1. Download the latest release package
2. Verify the SHA-256 checksum for integrity
3. Extract to `~/.local/share/odoo-manager/`
4. Create the `odoo-manager` command globally
5. Install Bash and Zsh tab-completion
6. Ask you to choose a license option

### Licensing — Free Tier Available!

Odoo Development Manager offers **two tiers:**

#### Free Tier (First 100 Developers)

During installation, select **Option 1** and register with your name + email.
You'll receive an instant `ODM-FREE-XXXX-XXXX` license key with lifetime access to:

- Workspace management (create, start, stop Odoo environments)
- Database manager (create, drop, backup, restore, clone)
- Git integration (status, commit, push, pull, stash)
- Module management (create, upgrade, manifest inspector)
- Config profiles, notes, time tracker, aliases
- Environment export/import

#### Pro Tier (Paid — All Features)

Upgrade to unlock advanced tools:

- Advanced Module Scaffold, Dependency Graph, Quality Checker
- Batch Operations, Hot Reload, DB Migration, DB Compare
- Multi-Database Testing, Remote Server Management

**To get a Pro key:** Contact **nisarzaidi75@gmail.com** / **+92-301-2122387**

#### Already Installed?

```bash
odoo-manager register          # Register for free tier later
odoo-manager license-status    # Check your current tier
```

---

## First Launch

When you run `odoo-manager` for the first time:

1. **No workspaces found** → The Workspace Wizard starts automatically
2. **Choose Odoo version** (13 through 19)
3. **Wizard clones Odoo** from GitHub automatically
4. **Creates Python virtual environment** with the correct Python version
5. **Installs all dependencies** from `requirements.txt`
6. **Generates `odoo.conf`** with unique ports for this version
7. **Creates project directories**

After setup, you land in the **Development Menu** — your main workspace.

---

## Interactive Menu Reference

The Development Menu is your main dashboard. Each key triggers a specific action:

### Odoo Management

| Key | Action | Description |
|---|---|---|
| **S** | Start Odoo | Start the Odoo server for the current workspace |
| **R** | Restart Odoo | Stop and restart the server |
| **K** | Stop Odoo | Stop the running Odoo server |
| **L** | View Logs | Live tail of `odoo.log` with auto-rotation support |
| **X** | Shell Shortcuts | Quick access to Odoo shell, psql, venv, bash |
| **Z** | Log Search | Interactive grep/filter by keyword or log level |

### Module Management

| Key | Action | Description |
|---|---|---|
| **U** | Upgrade Module | Install or upgrade a module against the database |
| **M** | Create New Module | Scaffold a new module via `odoo-bin` |
| **I** | Manifest Inspector | Inspect `__manifest__.py` of all modules |

### Database and Workspace

| Key | Action | Description |
|---|---|---|
| **D** | Database Manager | List, create, duplicate, backup, restore, drop databases |
| **A** | Backup / Restore | Workspace backup, snapshots, auto-backup scheduler |
| **H** | Workspace Doctor | Health check with auto-repair for common issues |
| **E** | Export Support Bundle | Package config + logs + system info for troubleshooting |
| **N** | Workspace Notes | Persistent notes/TODOs per workspace and project |

### Development Tools

| Key | Action | Description |
|---|---|---|
| **O** | Update Odoo Core | Pull latest Odoo source from git |
| **V** | Open in Editor | Open project or module in VS Code / Cursor / PyCharm |
| **G** | Git Status | Per-project git status, commit, push, pull, stash |
| **C** | Configuration | View/edit `odoo.conf`, addons path, enterprise detection |
| **T** | Quality Checks | Run tests (pytest) and lint (flake8) on projects |

### Advanced Tools (Development Menu)

| Key | Action | Description |
|---|---|---|
| **7** | Advanced Module Scaffold | Create modules with full boilerplate (models, views, security, wizards, controllers) |
| **8** | Module Dependency Graph | Visualize dependencies, detect circular deps |
| **9** | Module Quality Checker | Score modules 0-10, detect common issues |
| **M** | DB Migration Helper | Compatibility check for version upgrades |
| **W** | DB Snapshot & Compare | Schema snapshots and diff between databases |
| **P** | Multi-Database Testing | Test modules against multiple databases |

> **Hot Reload:** Press **S** then **2** to start Odoo with auto-restart on file changes.

### Global Tools (Workspace Selection Screen)

| Key | Action | Description |
|---|---|---|
| **B** | Batch Operations | Start/stop/backup all workspaces at once |
| **E** | Environment Templates | Save/restore workspace configurations |
| **M** | Remote Server Mgmt | Manage remote Odoo instances via SSH |
| **A** | Custom Aliases | Define your own shortcut commands |

### Project Tools (Project Selection Screen)

| Key | Action | Description |
|---|---|---|
| **T** | Time Tracker | Track hours per project, CSV export |
| **D** | Project Metadata | Store client name, description, deadline |
| **S** | Team Sync | Export/import workspace config for team sharing |

### Overview and Environment

| Key | Action | Description |
|---|---|---|
| **1** | Dashboard | Unified overview of all workspaces |
| **2** | Config Profiles | Save/load named presets (dev, staging, prod) |
| **3** | System Resource Check | CPU, memory, disk, PostgreSQL status |
| **4** | License Info | View license details |
| **5** | Export Environment | Archive workspace for migration |
| **6** | Import Environment | Restore from environment archive |

### Navigation

| Key | Action | Description |
|---|---|---|
| **F** | Toggle Favorite Workspace | Mark workspace as favorite for quick access |
| **J** | Toggle Favorite Project | Mark project as favorite |
| **W** | Change Workspace | Switch to a different workspace |
| **P** | Change Project | Switch to a different project |
| **B** | Back | Go back to project selection |
| **Q** | Quit | Exit (stops all running Odoo instances) |

---

## CLI Command Reference

Every core action is available as a direct command for scripts and automation:

### Server Control

```bash
odoo-manager start   --workspace odoo18 [--project agri]   # Start Odoo
odoo-manager stop    --workspace odoo18                     # Stop Odoo
odoo-manager restart --workspace odoo18 [--project agri]   # Restart Odoo
odoo-manager status  [--workspace odoo18] [--json]          # Show status
odoo-manager doctor  --workspace odoo18 [--json]            # Health report
```

### Quick Shortcuts

```bash
odoo-manager open   --workspace odoo18 --project agri    # Open in editor
odoo-manager logs   --workspace odoo18                   # Tail log file
odoo-manager shell  --workspace odoo18                   # Odoo shell
odoo-manager psql   --workspace odoo18 [--db mydb]       # PostgreSQL shell
odoo-manager test   --workspace odoo18 --project agri    # Run tests
odoo-manager lint   --workspace odoo18 --project agri    # Run linter
```

### Workspace Info

```bash
odoo-manager list    [--json]                            # List all workspaces
odoo-manager check-db-connection                          # Test PostgreSQL
```

### Advanced Tools

```bash
odoo-manager scaffold  --workspace odoo18 --project agri  # Advanced scaffold
odoo-manager quality   --workspace odoo18                 # Quality checker
odoo-manager deps      --workspace odoo18                 # Dependency graph
odoo-manager batch                                         # Batch operations
odoo-manager templates                                     # Env templates
odoo-manager timetrack                                     # Time tracker
odoo-manager aliases                                       # Custom aliases
odoo-manager remote                                        # Remote servers
odoo-manager migration --workspace odoo18                  # Migration helper
odoo-manager dbcompare --workspace odoo18                  # DB compare
odoo-manager multitest --workspace odoo18                  # Multi-DB testing
```

### General

```bash
odoo-manager --help          # Show help
odoo-manager --version       # Show version
odoo-manager --auto-update   # Launch with auto-update check
```

---

## Workspace Management

### What is a Workspace?

A workspace is a complete, isolated Odoo development environment. Each workspace contains:

```
Documents/
└── odoo18/                    # Workspace root
    ├── odoo/                  # Odoo Community source code
    │   └── odoo/odoo-bin      # Odoo executable
    ├── enterprise/            # Odoo Enterprise modules (optional)
    ├── env/                   # Python virtual environment
    ├── debian/
    │   └── odoo.conf          # Configuration file
    ├── projects/              # Your development projects
    │   ├── project-a/
    │   │   └── custom_addons/ # Custom modules
    │   └── project-b/
    │       └── custom_addons/
    └── logs/
        └── odoo.log           # Auto-rotating log file
```

### Creating a Workspace

1. Run `odoo-manager`
2. If no workspace exists, the wizard starts automatically
3. Choose your Odoo version
4. Wait for cloning, venv creation, and dependency installation
5. Your workspace is ready

To create additional workspaces:
1. Press **W** to change workspace
2. Select "Create New Workspace"
3. Choose a different Odoo version

### Switching Workspaces

Press **W** from any menu to switch between workspaces. Favorites appear at the top.

### Multi-Instance Support

Each Odoo version gets unique ports automatically:

| Odoo Version | HTTP Port | Longpolling Port |
|---|---|---|
| 13 | 8013 | 8073 |
| 14 | 8014 | 8074 |
| 15 | 8015 | 8075 |
| 16 | 8016 | 8076 |
| 17 | 8017 | 8077 |
| 18 | 8018 | 8078 |
| 19 | 8019 | 8079 |

This means you can run Odoo 16, 17, and 18 simultaneously without port conflicts.

---

## Project Management

### Creating a Project

1. From the Development Menu, press **P** to change project
2. Select "Create New Project"
3. Enter project name
4. The project generator optionally:
   - Creates the project folder under `projects/`
   - Initializes a git repository
   - Scaffolds a first module

### Switching Projects

Press **P** to switch between projects in the current workspace. Recent projects appear at the top.

### Favorites

Press **F** to favorite a workspace, **J** to favorite a project. Favorites appear at the top of selection lists.

---

## Module Development

### Creating a Module (Basic)

Press **M** from the Development Menu to create a module via `odoo-bin scaffold`.

### Creating a Module (Advanced) — Key **7**

The Advanced Module Scaffold creates production-ready modules with:

**Standard module (option 1):**
- `__manifest__.py` with proper dependencies
- `models/` with a model class, state field, action methods
- `views/` with tree, form, search views + menu items
- `security/` with groups and access rules CSV
- `data/demo.xml` with sample data

**Wizard module (option 2):**
- Everything in Standard, plus:
- `wizard/` with a transient model and wizard views

**Report module (option 3):**
- QWeb report templates

**Full module (option 4):**
- Everything above, plus:
- `controllers/` with HTTP and JSON endpoints

### Upgrading a Module

Press **U** from the Development Menu:
1. Select the module to upgrade
2. Select the target database
3. The tool runs `odoo-bin -d <db> -u <module> --stop-after-init`
4. Optionally restarts Odoo

### Manifest Inspector

Press **I** to inspect `__manifest__.py` of every module:
- Module name, version, category
- Dependencies list
- Data files referenced
- `auto_install` status
- Installability check

---

## Database Operations

### Database Manager (Key **D**)

Full database management with:
- **List** all databases
- **Create** new database
- **Duplicate** existing database
- **Backup** database (custom format dump)
- **Restore** from backup file
- **Drop** database (with safety backup)
- **Clone & Run** — duplicate DB + restore + start Odoo in one step

### DB Snapshot & Compare (Key **W**)

1. **Take Snapshot** — captures the current database schema
2. **Compare Snapshots** — select two snapshots to see:
   - Tables added/removed
   - Detailed schema diff (columns, indexes, constraints)

Useful before/after module upgrades to verify database changes.

### Multi-Database Testing (Key **P**)

1. **Add test databases** — register databases for testing
2. **Run module test** — upgrades a module against all test databases
3. See pass/fail results per database

---

## Backup and Restore

### Workspace Backup (Key **A**)

- **Backup** — archives addons, enterprise, projects, config into a `.tar.gz`
- **Restore** — restores from a backup file
- **Snapshots** — point-in-time backup with doctor report
- **Auto Backup** — set up cron-based scheduled backups with retention cleanup

### Batch Backup (Key **B** - Workspace screen)

Backup all databases across all workspaces in one operation.

---

## Advanced Tools Guide

### Hot Reload (Key **S → 2**)

1. Press **S** → **2** from the Development Menu
2. Odoo starts with file watching enabled
3. Edit any `.py`, `.xml`, or `.csv` file in your project
4. Odoo automatically restarts when changes are detected
5. Press `Ctrl+C` to stop

**Requirement:** `inotify-tools` package (auto-installs on first use)

### Module Quality Checker (Key **9**)

Scans all modules and gives a score from 0 to 10:

**Checks performed:**
- `__manifest__.py` completeness (name, description, license, author)
- `print()` usage (should use `logging` instead)
- Bare `except:` clauses (should catch specific exceptions)
- Missing `# -*- coding: utf-8 -*-` headers
- Missing `security/ir.model.access.csv`
- Missing `__init__.py`
- Hardcoded ID references in XML

### Module Dependency Graph (Key **8**)

Shows a tree of module dependencies:
- **Green** = local module (in your project)
- **White** = external dependency (Odoo core or third-party)
- Automatically detects circular dependencies

### Batch Operations (Key **B** - Workspace screen)

- **Start All** — start every workspace that isn't running
- **Stop All** — stop all running Odoo instances
- **Backup All** — dump all databases across all workspaces
- **Upgrade Module** — upgrade a module across all workspaces

### Environment Templates (Key **E** - Workspace screen)

Save your workspace setup as a reusable template:
1. **Save** — captures Odoo version, port, projects list, enterprise status
2. **Load** — creates a new workspace using template settings
3. **Delete** — remove old templates

### Time Tracker (Key **T** - Project screen)

1. **Start Tracking** — begins timing the current project
2. **Stop Tracking** — records the session duration
3. **View Report** — shows total time and recent sessions
4. **Export CSV** — exports all tracking data for invoicing

### Project Metadata (Key **D** - Project screen)

Store per-project information:
- Client name
- Project description
- Deadline (YYYY-MM-DD format)

Deadlines are shown with warnings:
- **Red** = overdue
- **Yellow** = within 7 days
- **White** = more than 7 days away

### Custom Aliases (Key **A** - Workspace screen)

Define shortcut commands:
1. **Add Alias** — give a name and the command it should run
2. Example: name `dev`, command `start --workspace odoo18 --project agri`
3. Run: `odoo-manager dev` — executes the mapped command

### Team Sync (Key **S** - Project screen)

1. **Export** — creates `.odoo-team.json` in the workspace root
2. Commit this file to git
3. Team members pull the file
4. **Import** — creates missing project directories from the config

### DB Migration Helper (Key **M**)

1. **Compatibility Check** — scans modules for deprecated API usage:
   - `from openerp` imports (deprecated since v9)
   - `@api.multi` decorator (deprecated since v13)
   - `@api.one` decorator (deprecated since v13)
2. **Migration Checklist** — generates a 4-phase checklist:
   - Phase 1: Preparation (backup, create workspace, check compatibility)
   - Phase 2: Code Migration (update APIs, views, security)
   - Phase 3: Data Migration (restore DB, run migration, verify)
   - Phase 4: Go-Live (final sync, UAT, deploy)

---

## Team Collaboration

### Sharing Workspace Config

1. Press **S** (Project screen) → Export Team Config
2. `.odoo-team.json` is created in your workspace root
3. Commit to git: `git add .odoo-team.json && git commit -m "Share workspace config"`
4. Team members pull and press **S** (Project screen) → Import Team Config
5. Missing project directories are created automatically

### Sharing Templates

1. Press **E** (Workspace screen) → Save Current Workspace as Template
2. Templates are stored in `~/.local/share/odoo-manager/templates/`
3. Share the `.json` file manually with teammates
4. They place it in the same directory and use Load Template

---

## Remote Server Management

### Adding a Remote Server

1. Press **\*** → **A** (Add Remote Server)
2. Enter:
   - Server name (e.g., `staging`)
   - SSH host (e.g., `192.168.1.100`)
   - SSH user (default: `odoo`)
   - SSH port (default: `22`)
   - Remote Odoo directory (default: `/opt/odoo`)
   - Remote config file (default: `/etc/odoo/odoo.conf`)
   - Remote service name (default: `odoo`)

### Remote Operations

- **Check Status** — `systemctl is-active <service>` via SSH
- **Start** — `sudo systemctl start <service>` via SSH
- **Stop** — `sudo systemctl stop <service>` via SSH
- **Restart** — `sudo systemctl restart <service>` via SSH
- **View Logs** — `tail -f` the remote log file via SSH

---

## Troubleshooting

### Odoo Won't Start

1. Press **H** (Workspace Doctor) — it checks and auto-repairs common issues:
   - Stale PID files
   - Port conflicts
   - Missing dependencies
   - Unsafe `addons_path` values
   - PostgreSQL connectivity

2. Check the log: Press **L** or run `odoo-manager logs --workspace <name>`

3. Check port: `odoo-manager status --workspace <name>`

### Port Conflict

If a port is already in use:
1. The tool refuses to start and tells you which port is busy
2. Edit `odoo.conf` (press **C**) and change `http_port`
3. Or stop the other process using that port

### Database Connection Failed

1. Ensure PostgreSQL is running: `sudo systemctl status postgresql`
2. Test connectivity: `odoo-manager check-db-connection`
3. Check `db_user` and `db_password` in config (press **C**)

### Module Not Found During Upgrade

1. Check that the module is in `custom_addons/` under your project
2. Press **C** (Configuration) to verify the `addons_path` includes your module directory
3. Restart Odoo after adding new modules

### Update Failed

1. Run `odoo-manager --auto-update` to force an update check
2. If git pull fails, you may have uncommitted changes:
   - Press **G** (Git Status)
   - Stash your changes
   - Try updating again

---

## FAQ

**Q: How do I run multiple Odoo versions at the same time?**
A: Create separate workspaces for each version. Each gets unique ports automatically. Start them simultaneously — they won't conflict.

**Q: Where are my workspaces stored?**
A: By default in `~/Documents/`. Override with `ODOO_MANAGER_WORKSPACE_ROOT=/custom/path odoo-manager`.

**Q: Can I use this with Odoo Enterprise?**
A: Yes. Drop Enterprise modules into the `enterprise/` folder in your workspace. The tool auto-detects them and adds them to the addons path.

**Q: How do I backup everything?**
A: Press **B** (Workspace screen) → Backup All Databases. Or press **A** in any workspace for individual backup/restore.

**Q: How do I share my setup with a new team member?**
A: Press **S** (Project screen) to export team config, commit to git. They install the tool, enter their license key, pull the repo, and press **S** (Project screen) to import.

**Q: Can I use this in CI/CD pipelines?**
A: Yes. All commands work in non-interactive CLI mode with `--json` output for machine-readable results.

**Q: How do I track time for billing?**
A: Press **T** (Project screen) → Start Tracking. Stop when done. Export to CSV for invoicing.

**Q: Can I test a module against production data?**
A: Press **P** → Add your production copy as a test database. Run module tests against all registered databases.

**Q: What if I need to upgrade Odoo from v16 to v17?**
A: Press **M** → Compatibility Check to see which modules need updates. Then follow the Migration Checklist for a step-by-step guide.

**Q: How do I get support?**
A: Contact the developer:
- **Email:** nisarzaidi75@gmail.com
- **Phone/WhatsApp:** +92-301-2122387
