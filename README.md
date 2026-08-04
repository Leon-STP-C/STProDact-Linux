# STProDact-Linux

The purpose of this project is to try to provide an automated Setup for STProDact for Linux-Systems via the usage of Docker Containers. `STProDact.iss` in this repo is the Windows setup equivalent to serve as a reference. The handling of dependencies in the environment is mainly done via `flake.nix` which is being run through the `.envrc.` Make sure to follow the [Prerequisites](#prerequisites) section to ensure proper functionality.

# Prerequisites

## Manual
Since flake.nix handles most dependencies this requires Nix to be installed on the system. The Nix package manager can be downloaded [here](https://nixos.org/download/).\
For this to work direnv also has to be setup on the system. A basic installation guide can be found [here](https://github.com/direnv/direnv#basic-installation)

**IMPORTANT!**\
While Nix handles docker and all its tools, the docker daemon itself still needs to be installed and setup manually for your distribution.

## Debian/Ubuntu
For Debian/Ubuntu based distributions you can run the provided script in `bootstrap/debian-ubunutu.sh`\
NOTE: If you're re-running this script its best to run outside of the dev shell as it may introduce bugs.
> To bypass the Docker install method prompt you may also set the DOCKER_INSTALL_METHOD environment variable to either "official" or "apt"\
> The same applies to DBeaver which is an optional Database management tool to mirror HeidiSQL in the Windows installer.\
> As example:
```bash
DOCKER_INSTALL_METHOD=official ./bootstrap/debian-ubuntu.sh
```

# Getting Started

## Start the stack

All Docker files live in `src/`. From inside the dev shell (or with Docker available) run:

```bash
cd src
docker compose up -d --build
```

This starts three containers, mirroring the Windows setup:

| Windows service (STProDact.iss) | Container  | Image          | Purpose                                  |
| ------------------------------- | ---------- | -------------- | ---------------------------------------- |
| `MySQLSTProDact`                | `db`       | `mysql:8.4`    | MySQL with `opcua` database and user     |
| `STProDactApp`                  | `app`      | built locally  | Node.js application (OPC-UA, web UI)     |
| `STProDactProxy`                | `proxy`    | `caddy:2`      | Reverse proxy, publishes port 80         |

On first start the MySQL data directory is initialized and `src/db/init.sql` creates
the `opcua` database and the `opcua` user exactly like the Windows installer does
(`utf8mb4` / `utf8mb4_0900_ai_ci`, `opcua`/`opcua`, full privileges on `opcua.*`).

The application is then reachable at `http://localhost:80` (or the `HTTP_PORT`
you configured in `.env`).

### Configuration

Copy `src/.env.example` to `src/.env` to change the MySQL root password, the
database credentials, or the HTTP port. The database values are only applied
when the `mysql_data` volume is first initialized.

The web application is reached on host port 80 by default (`HTTP_PORT`). If
that port is already used on the host set `HTTP_PORT` to a free port in `.env`, e.g..
```bash
HTTP_PORT=8080
```

The app itself always listens on port 3000 inside its container, so the access
URL simply becomes `http://localhost:8080`.

To reach MySQL from the host (e.g. with a DB manager, the Linux counterpart of the
optional HeidiSQL component), uncomment this line in `compose.yaml`:

```yaml
#      - "127.0.0.1:3306:3306"
```

## Maintenance

The Windows maintenance page lets you reinstall or uninstall components and remove
application data. The Docker equivalents:

| Windows action                | Docker command                                              |
| ----------------------------- | ----------------------------------------------------------- |
| Install / reinstall core      | `docker compose up -d --build --force-recreate`             |
| Stop all services             | `docker compose stop`                                       |
| Uninstall (keep data)         | `docker compose down`                                       |
| Uninstall (remove data)       | `docker compose down -v` (removes all named volumes)        |
| Restart MySQL only            | `docker compose restart db`                                 |
| View logs                     | `docker compose logs -f app`                                |

Removing application data (`docker compose down -v`) deletes the MySQL databases,
logs, configuration, app data, profile and Caddy data — the equivalent of the
"Remove application data" checkbox in the installer.

## Notes

- The Windows installer bound MySQL to `127.0.0.1`. Inside Docker the database
  is only exposed on the internal compose network; the app container reaches it
  via the `db` hostname. No MySQL port is published to the host by default.
- On reinstall, existing data is reused automatically: the MySQL init scripts
  only run when the `mysql_data` volume is empty, matching the installer's
  "reuse existing data" behaviour.
- The app payload in `src/` (server.js, package.json, node_modules) is the
  counterpart of `{app}\app`; replace it with your actual ST-PRO DACT
  application package if needed.