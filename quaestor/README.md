# Quaestor

Runs [Quaestor](https://github.com/felixschndr/quaestor), a self-hosted, read-only bank account/transaction dashboard, as a Home Assistant add-on.

This add-on wraps the upstream `ghcr.io/felixschndr/quaestor` image; it does not fork or reimplement the app itself. See the [upstream project](https://github.com/felixschndr/quaestor) for a full feature overview and screenshots.

## Installation

1. In Home Assistant: **Settings → Add-ons → Add-on Store → ⋮ → Repositories**.
2. Add this repository's URL.
3. Install **Quaestor** from the store, open its **Configuration** tab and set at least `database_encryption_key`.
4. Start the add-on, then open the web UI from the add-on's **Info** page.

## Configuration

| Option | Description |
|---|---|
| `database_encryption_key` | **Required.** Key used to encrypt the database. Pick a strong random value and keep it safe, losing it makes the data unreadable. |
| `allow_new_user_registration` | Whether new users may sign up on this instance. |
| `default_language` | `en` or `de`. Only affects the default for new users. |
| `default_currency` | Display currency (symbol/format only) for new users. |
| `display_timezone` | IANA time zone (e.g. `Europe/Berlin`) used to render timestamps. |
| `log_level` | `DEBUG`, `INFO`, `WARNING` or `ERROR`. Don't use `DEBUG` long-term, it logs request/response data. |
| `sync_interval_hours` | How often credentials without 2FA are auto-synced. Accepts fractional values. |
| `max_attachment_size_mb` | Maximum size of a single transaction attachment. |
| `forwarded_allow_ips` | Comma-separated list of reverse-proxy IPs to trust `X-Forwarded-For`/`X-Forwarded-Proto` from, or `*`. Leave empty unless you put a reverse proxy in front (see below). |

Data (including the encrypted SQLite database) is stored in the add-on's own persistent `/data` folder, managed by the Supervisor. It survives restarts, updates and rebuilds of the add-on; it is only removed if you uninstall the add-on.

## Notes

- Push notifications require HTTPS. Browsers only allow them in a secure context, and this add-on serves plain HTTP itself. If you need notifications, put a reverse proxy with TLS in front, e.g. Home Assistant's built-in reverse proxy/ingress or add-ons like Nginx Proxy Manager or Cloudflare Tunnel. When you do:
  - set `forwarded_allow_ips` to the proxy's IP (or `*`, since container IPs in the Docker network aren't fixed),
  - make sure the proxy allows/forwards WebSocket upgrades, the app needs it.
- Bank data is stored encrypted in the add-on's private `/data` folder, using `database_encryption_key`. Losing that key makes existing data unreadable, back it up outside Home Assistant.
- See the [upstream README](https://github.com/felixschndr/quaestor#environment-variables) for what each option does.
