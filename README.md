# 🚀 Odoo Manager

<p align="center">
  <img src="https://img.shields.io/badge/version-4.0-blue?style=for-the-badge" alt="Version" />
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20Ubuntu-lightgrey?style=for-the-badge&logo=linux" alt="Platform" />
  <img src="https://img.shields.io/badge/shell-Bash-4EAA25?style=for-the-badge&logo=gnu-bash" alt="Bash" />
  <img src="https://img.shields.io/badge/license-commercial-red?style=for-the-badge" alt="Commercial License" />
</p>

<p align="center">
A complete command-line toolkit for Odoo developers. Manage multiple Odoo workspaces, install development tools, configure environments, manage databases, control Odoo servers, and automate your entire development workflow from a single CLI.
</p>

---

# ✨ Features

| Category                | Feature                                                                            |
| ----------------------- | ---------------------------------------------------------------------------------- |
| **Core**                | Interactive CLI, Multi Workspace Support, Odoo 13 → Odoo 19                        |
| **Workspace**           | Automatic Workspace Detection, Workspace Wizard, Multi-Workspace Management        |
| **Development Tools**   | Install Visual Studio Code, Cursor and PyCharm Community directly from the CLI     |
| **System Requirements** | Install Git, Python 3, pip, PostgreSQL and OpenSSL with one click                  |
| **Environment**         | Automatic Python Virtual Environment, Automatic `requirements.txt` Installation    |
| **Configuration**       | Automatic Configuration Generation, Dynamic Addons Path, Enterprise Auto Detection |
| **Projects**            | Project Detection, Create New Module                                               |
| **Server Control**      | Start / Stop / Restart Odoo, Multi-Instance Support                                |
| **Editor**              | Open Project in VS Code, Cursor or PyCharm with automatic installation if missing  |
| **Logging**             | Live Log Viewer, Automatic Log Rotation                                            |
| **Backup**              | Workspace Backup & Restore                                                         |
| **Database**            | Database Manager (Create, Duplicate, Backup, Restore, Drop)                        |
| **Modules**             | Module Upgrade Manager                                                             |
| **Diagnostics**         | Workspace Doctor (Health Check & Auto Repair)                                      |
| **Automation**          | Non-Interactive CLI Mode (Scripting & CI/CD)                                       |
| **Version Control**     | Git Integration (Branch, Status, Pull, Commit & Push)                              |
| **Updates**             | Built-in Update Checker and `--auto-update`                                        |

---

# 📦 Installation

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/NisarZaidi/odoo-manager-releases/main/install.sh)
```

> **Important:** Use `bash <(curl ...)`, **not** `curl ... | bash`.

During installation you'll be asked to enter your **License Key**.

The license key is provided after purchase and only needs to be activated once. It is securely stored on your machine, so reinstalling or updating later won't ask for it again.

---

# ⚙️ System Requirements

Odoo Manager can automatically install missing dependencies directly from the CLI.

Supported packages:

* Git
* Python 3
* pip
* PostgreSQL
* OpenSSL

If anything is missing, simply choose **Install All Missing** to prepare your development environment automatically.

---

# 🛠 Development Tools

Install your favorite editor directly from Odoo Manager.

Supported editors:

* Visual Studio Code
* Cursor
* PyCharm Community Edition

Features include:

* Automatic editor detection
* One-click installation
* Open current project directly
* Install missing editor automatically
* Install All Missing shortcut

---

# 🚀 Getting Started

Launch the manager:

```bash
odoo-manager
```

If no workspace exists, the **Workspace Wizard** starts automatically.

It will:

1. Select an Odoo version (13–19)
2. Clone Odoo Community
3. Create a Python virtual environment
4. Install Python dependencies
5. Generate `odoo.conf`
6. Configure unique ports
7. Create a `projects/` directory

After setup you'll be taken directly to your development workspace.

---

# 🌐 Multi-Instance Support

Each workspace uses its own HTTP and Longpolling ports, allowing multiple Odoo versions to run simultaneously.

Example:

| Version | HTTP | Longpolling |
| ------- | ---- | ----------- |
| Odoo 17 | 8239 | 8242        |
| Odoo 18 | 8249 | 8252        |
| Odoo 19 | 8259 | 8262        |

Stopping Odoo Manager automatically stops every running Odoo instance started by the manager.

---

# 💻 Non-Interactive CLI

Perfect for automation, scripting and CI/CD.

```bash
odoo-manager start --workspace odoo18 --project my_project

odoo-manager stop --workspace odoo18

odoo-manager restart --workspace odoo18 --project my_project

odoo-manager status

odoo-manager list

odoo-manager list --json

odoo-manager check-db-connection

odoo-manager --auto-update

odoo-manager --help
```

---

# ⌨️ Shell Completion

Bash and Zsh auto-completion are installed automatically.

Example:

```bash
odoo-manager <TAB>

odoo-manager start --workspace <TAB>
```

---

# 🔄 Updating

Update to the latest release anytime.

```bash
odoo-manager --auto-update
```

Or simply run the installation command again.

Your license remains activated.

---

# 🗑 Uninstall

```bash
~/.local/share/odoo-manager/uninstall.sh
```

Only Odoo Manager is removed.

Your workspaces, databases, projects, virtual environments and configuration remain untouched.

---

# ❓ Troubleshooting

### Invalid License Key

Verify that the complete license key has been copied correctly.

If the issue continues, contact support.

### PostgreSQL Connection Failed

Install PostgreSQL from the **System Requirements** menu or use **Workspace Doctor** to diagnose the issue.

### Port Already In Use

Update the workspace configuration or stop the process using that port.

---

# 📄 License

This is **commercial software**.

A valid lifetime license key is required to install and use Odoo Manager.

The public repository contains the installer and release packages only.

The full source code is maintained in a private repository.

---

# 👨‍💻 Author

**Nisar Zaidi**

GitHub: https://github.com/NisarZaidi

---

# ❤️ Support

Need a license key, lost your key, or need help?

**Email**

[nisarzaidi75@gmail.com](mailto:nisarzaidi75@gmail.com)

**WhatsApp**

+92 301 2122387

Please include your purchase email or name when requesting license assistance.

---

<p align="center">
Built with ❤️ for the Odoo Developer Community.
</p>
