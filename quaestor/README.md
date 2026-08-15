# Quaestor

Consolidates the balances and transactions from all your banks into a single, private, self-hosted view. See the [upstream project](https://github.com/felixschndr/quaestor) for a full feature overview and screenshots.

## Configuration

| Option | Description |
|---|---|
| `database_encryption_key` | **Required.** Key used to encrypt the database. Pick a strong random value and keep it safe — losing it makes the data unreadable. |
| `allow_new_user_registration` | Whether new users may sign up on this instance. |
| `default_language` | `en` or `de`. Only affects the default for new users. |
| `default_currency` | Display currency (symbol/format only) for new users. |
| `display_timezone` | IANA time zone (e.g. `Europe/Berlin`) used to render timestamps. |
| `log_level` | `DEBUG`, `INFO`, `WARNING` or `ERROR`. Don't use `DEBUG` long-term, it logs request/response data. |
| `sync_interval_hours` | How often credentials without 2FA are auto-synced. Accepts fractional values. |
| `max_attachment_size_mb` | Maximum size of a single transaction attachment. |
| `forwarded_allow_ips` | Comma-separated list of reverse-proxy IPs to trust `X-Forwarded-For`/`X-Forwarded-Proto` from, or `*`. Leave empty unless you put a reverse proxy in front (see below). |

Data (including the encrypted SQLite database) is stored in the add-on's own persistent `/data` folder, managed by the Supervisor. It survives restarts, updates and rebuilds of the add-on; it is only removed if you uninstall the add-on.

## HTTPS / push notifications

Browsers only allow push notifications over a secure context. This add-on serves plain HTTP; put a reverse proxy with TLS in front of it if you need notifications to work, and:

- set `forwarded_allow_ips` to the proxy's IP (or `*`, since container IPs in the Docker network aren't fixed),
- make sure the proxy allows/forwards WebSocket upgrades — the app needs it.
