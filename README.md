# 🚀 Odoo Development Manager

<p align="center">
  <img src="https://img.shields.io/badge/version-2.0-blue?style=for-the-badge" alt="Version" />
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20Ubuntu-lightgrey?style=for-the-badge&logo=linux" alt="Platform" />
  <img src="https://img.shields.io/badge/shell-Bash-4EAA25?style=for-the-badge&logo=gnu-bash" alt="Bash" />
  <img src="https://img.shields.io/badge/license-commercial-red?style=for-the-badge" alt="Commercial License" />
</p>

<p align="center">
A professional CLI tool to manage multiple Odoo development environments and projects from a single command.
</p>

---

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/<your-username>/odoo-manager-releases/main/install.sh)
```

> Use `bash <(curl ...)`, not `curl ... | bash` — the installer asks for
> your license key interactively, and piping into `bash` would steal the
> terminal input needed for that prompt.

You'll be asked for a **license key** during install. This is a single line
of text sent to you directly by the seller (email / WhatsApp) after
purchase — not a file, just paste it in when prompted.

> Don't have a key yet? Contact **Nisar Zaidi** to purchase one (see
> [Support](#support) below).

The key is a **lifetime license** — pay once, use forever on the machine
you activate it on. It's cached locally after first activation, so
reinstalling or updating later won't ask again.

---

## What You Get

| Category | Feature |
|---|---|
| **Core** | Interactive CLI, Multi Workspace Support, Odoo 13 → Odoo 19 |
| **Setup** | Automatic Workspace Detection & Setup Wizard, Automatic Odoo Community Clone |
| **Environment** | Automatic Python Virtual Environment, Automatic `requirements.txt` Installation |
| **Configuration** | Automatic Configuration Generation, Dynamic Addons Path, Enterprise Auto-Detection |
| **Projects** | Project Detection, Create New Module |
| **Server Control** | Start / Stop / Restart Odoo, Multi-Instance Support (own port per workspace) |
| **Logging** | Live Log Viewer (auto rotating), Automatic Log Rotation |
| **Editor** | Open Project in VS Code / Cursor |
| **Backup** | Workspace Backup & Restore (addons + projects + config) |
| **Database** | Database Manager (create, duplicate, backup, restore, drop) |
| **Modules** | Module Upgrade |
| **Diagnostics** | Workspace Doctor (health check + auto-repair) |
| **Automation** | Non-Interactive CLI Mode (scripting / cron) |
| **Maintenance** | Update Checker (checks GitHub on startup) |
| **Version Control** | Git Integration (per-project branch/status, pull, log, commit & push) |

---

## Requirements

- Ubuntu / Linux
- Git, Python 3, pip, PostgreSQL — the installer checks for these and offers
  to install anything missing via `apt-get`
- `openssl` (used to verify your license key)

---

## After Install

```bash
odoo-manager
```

First run detects that no workspace exists yet and starts the **Workspace
Wizard**, which will:

1. Ask which Odoo version you want (13–19)
2. Clone Odoo Community
3. Set up a Python virtual environment
4. Generate a default `odoo.conf` (with its own HTTP/longpolling port, so
   multiple versions can run side by side)
5. Create a `projects/` folder for your custom addons

From then on, launching `odoo-manager` takes you straight to the version →
project → Development Menu flow.

---

## Multi-Instance Support

Every workspace gets its own HTTP and longpolling port, calculated from its
Odoo version, so `odoo17`, `odoo18`, and `odoo19` can all run **at the same
time** without clashing:

| Odoo Version | HTTP Port | Longpolling Port |
|---|---|---|
| 17 | 8239 | 8242 |
| 18 | 8249 | 8252 |
| 19 | 8259 | 8262 |

Quitting the manager (`Q`) or `Ctrl+C` stops **every** running Odoo instance
across every workspace, so nothing keeps running in the background after
you exit.

---

## Non-Interactive CLI Mode

For scripts, cron jobs, or CI:

```bash
odoo-manager start   --workspace odoo18 --project agri
odoo-manager stop    --workspace odoo18
odoo-manager restart --workspace odoo18 --project agri
odoo-manager status                       # every workspace
odoo-manager status  --workspace odoo18   # one workspace
odoo-manager list                         # list all workspaces
odoo-manager list    --json               # machine-readable, for CI/CD
odoo-manager check-db-connection
odoo-manager --help
```

Exit codes: `0` on success, `1` on failure.

---

## Shell Tab-Completion

Installed automatically for both bash and zsh:

```bash
odoo-manager <TAB>
# start  stop  restart  status  list  check-db-connection  --auto-update  --help

odoo-manager start --workspace <TAB>
# odoo17  odoo18  odoo19
```

---

## Updating

```bash
odoo-manager --auto-update
```

Or re-run the install one-liner at the top of this file — it's safe to
run again on an existing install (your license key stays cached).

---

## Uninstall

```bash
~/.local/share/odoo-manager/uninstall.sh
```

This removes only the `odoo-manager` command itself. Your workspaces,
projects, databases, virtual environments, and logs are **not** touched.
Your saved license key is also kept, so reinstalling later won't ask
for it again.

---

## Troubleshooting

**"Invalid license key" after 3 attempts** — double-check you copied the
full key (it's one long line, no spaces). If it still fails, contact the
seller — your key may have been mistyped when issued.

**PostgreSQL not reachable** — the Workspace Wizard checks this before
creating a workspace and lets you continue anyway; fix connectivity later
and use Workspace Doctor (`H` in the Development Menu) to re-check.

**Port already in use** — Start Odoo will tell you which port is busy
instead of failing silently; change `http_port` in that workspace's
`odoo.conf` (Configuration menu → `C`) or stop whatever else is using it.

---

## License

This is **commercial software**. A valid lifetime license key (issued
per-customer) is required to install and use it. See [Install](#install)
above for how activation works.

The underlying tool code is distributed under the MIT License (see
[LICENSE](LICENSE)) — the license-key requirement governs *distribution/
activation*, not the underlying code terms.

---

## Author

**Nisar Zaidi** — [GitHub](https://github.com/NisarZaidi)

---

## Support

Need a license key, lost your key, or hit an issue?

- Email / WhatsApp: *(add your contact details here)*
- Please include the name/email you originally purchased under so your
  key can be looked up.

If you found this tool useful, ⭐ star this repo — it helps the project grow.

---

<p align="center">Built with ❤️ for the Odoo Developer Community.</p>
