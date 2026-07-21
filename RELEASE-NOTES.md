# Odoo Development Manager v2.1.0

**The all-in-one CLI tool that sets up, runs, and manages your Odoo development environments — so you can focus on coding, not configuration.**

Supports **Odoo 13 through 19** on Ubuntu Linux.

---

## 🚀 Install in One Command

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/NisarZaidi/odoo-manager-releases/main/install.sh)
```

> Use `bash <(curl ...)` — not `curl ... | bash` (the installer needs your input).

### What happens during install?

1. Downloads and installs the tool automatically
2. Asks you to choose a license:
   - **Free Tier** — enter your name + email, get an instant lifetime key (first 100 developers)
   - **Pro Tier** — paste the `ODM-PRO-XXXX-XXXX` key you received
3. Sets up shell tab-completion (bash + zsh)
4. Done — type `odoo-manager` to start

---

## 💰 Free Tier vs Pro Tier

### Free Tier (first 100 developers — lifetime)

Everything you need for daily Odoo development:

| Feature | What it does |
|---|---|
| **Workspace Manager** | Create, run, and manage multiple Odoo environments (v13–v19) |
| **Database Manager** | Create, drop, backup, restore, clone databases per workspace |
| **Module Management** | Create new modules, upgrade modules, inspect manifests |
| **Git Integration** | Commit, push, pull, stash — per project, with status badges |
| **Editor Support** | Open projects in VS Code, Cursor, or PyCharm |
| **Config Profiles** | Save/load presets for dev, staging, prod |
| **Time Tracker** | Track hours per project, export CSV for invoicing |
| **Workspace Notes** | Persistent TODOs and notes per workspace/project |
| **Custom Aliases** | Create your own shortcut commands |
| **Auto Backup** | Scheduled cron-based database backups |
| **Log Viewer** | Tail and search Odoo logs interactively |
| **Workspace Doctor** | Health check with auto-repair for common issues |

### Pro Tier (paid — all features)

Everything in Free, plus advanced developer tools:

| Feature | What it does |
|---|---|
| **Advanced Scaffold** | Create production-ready modules with full boilerplate |
| **Dependency Graph** | Visualize module dependencies, detect circular deps |
| **Quality Checker** | Score modules 0–10, detect common issues |
| **Hot Reload** | Auto-restart Odoo when you edit code files |
| **Batch Operations** | Start/stop/backup ALL workspaces at once |
| **DB Migration** | Compatibility check for version upgrades |
| **DB Snapshot & Compare** | Schema diff between databases |
| **Multi-DB Testing** | Test module upgrades against multiple databases |
| **Remote Server** | Control remote Odoo instances via SSH |
| **Team Sync** | Share workspace config with team via git |
| **Environment Templates** | Save/restore workspace configs as templates |

**To upgrade:** Contact **nisarzaidi75@gmail.com** / **+92-301-2122387**

---

## 🎯 What's New in v2.1.0

### Free Tier Now Available!

First 100 developers get a **lifetime free license** — no credit card, no trial period. Just register with your name and email during installation.

### Smarter Menu Layout

Tools are now organized by context across 3 screens — no more hunting through a massive menu:

- **Workspace Screen** — global tools (Batch Ops, Templates, Remote, Aliases)
- **Project Screen** — project tools (Time Tracker, Metadata, Team Sync)
- **Development Menu** — project-specific tools (Scaffold, Quality, Migration, etc.)

### Simple Keys (No More Special Characters)

Every menu option now uses a **letter or number** — no more `@`, `#`, `$`, `!`, `(`, etc.

### 15 New Advanced Tools

From hot reload to database comparison, v2.1 adds powerful tools for serious Odoo developers. See the full list in the Pro Tier section above.

---

## ⚡ Quick Start

```bash
odoo-manager
```

On first run, the Workspace Wizard guides you through:
1. Choose Odoo version (13–19)
2. Auto-clone Odoo from GitHub
3. Auto-create Python virtual environment
4. Auto-install all dependencies
5. Auto-generate `odoo.conf` with unique ports
6. Start developing!

### Multi-Version Support

Run multiple Odoo versions simultaneously — each gets its own ports:

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

## 💻 CLI Commands (for scripts and automation)

```bash
# Server Control
odoo-manager start   --workspace odoo18 --project agri
odoo-manager stop    --workspace odoo18
odoo-manager restart --workspace odoo18 --project agri
odoo-manager status                       # all workspaces
odoo-manager list                         # list workspaces

# Quick Shortcuts
odoo-manager open   --workspace odoo18 --project agri   # open in editor
odoo-manager logs   --workspace odoo18                  # tail log
odoo-manager shell  --workspace odoo18 --project agri   # Odoo shell
odoo-manager psql   --workspace odoo18 --db mydb        # PostgreSQL
odoo-manager test   --workspace odoo18 --project agri   # run tests
odoo-manager lint   --workspace odoo18 --project agri   # flake8/pylint

# Advanced Tools (Pro)
odoo-manager scaffold  --workspace odoo18 --project agri
odoo-manager quality   --workspace odoo18
odoo-manager deps      --workspace odoo18
odoo-manager batch
odoo-manager migration --workspace odoo18
odoo-manager dbcompare --workspace odoo18
odoo-manager multitest --workspace odoo18

# License
odoo-manager register          # self-service free signup
odoo-manager license-status    # check your tier
```

---

## 📦 What's in the Download

| File | Description |
|---|---|
| `odoo-manager.tar.gz` | Main package (bin + lib + shell completion) |
| `odoo-manager.tar.gz.sha256` | Checksum for download verification |

---

## 📋 System Requirements

- **Ubuntu 22.04 / 24.04 LTS** (or any Debian-based Linux)
- `bash`, `curl`, `tar`, `openssl`, `jq` (installer auto-checks these)

Everything else (Python, PostgreSQL, Git, editors) is installed automatically.

---

## 🔄 Updating

```bash
odoo-manager --auto-update
```

---

## 📬 Support & Contact

| Channel | Contact |
|---|---|
| **Free License** | Self-service during install (name + email) |
| **Pro License** | nisarzaidi75@gmail.com / +92-301-2122387 |
| **Bug Reports** | [GitHub Issues](https://github.com/NisarZaidi/odoo-manager-releases/issues) |
| **Documentation** | [User Manual](USER-MANUAL.md) |

---

## 📝 Notes

- License verified online via Supabase (with offline grace period)
- Free tier is lifetime — no expiry, no subscription
- Pro tier is lifetime — one-time purchase
- Source code maintained privately; public repo ships installer + releases only
- Currently supported on Ubuntu Linux (Debian-based)

---

Thank you for choosing **Odoo Development Manager** 🚀
