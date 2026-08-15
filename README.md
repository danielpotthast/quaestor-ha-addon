# Quaestor Home Assistant Add-on Repository

Runs [Quaestor](https://github.com/felixschndr/quaestor) — a self-hosted, read-only bank account/transaction dashboard — as a Home Assistant add-on.

This repository wraps the upstream `ghcr.io/felixschndr/quaestor` image; it does not fork or reimplement the app itself.

## Installation

1. In Home Assistant: **Settings → Add-ons → Add-on Store → ⋮ → Repositories**.
2. Add this repository's URL.
3. Install **Quaestor** from the store, open its **Configuration** tab and set at least `database_encryption_key`.
4. Start the add-on, then open the web UI from the add-on's **Info** page.

## Notes

- Push notifications require HTTPS. This add-on does not terminate TLS itself — put it behind Home Assistant's built-in reverse proxy / your own ingress (e.g. the Nginx Proxy Manager or Cloudflare Tunnel add-ons) if you need that.
- Bank data is stored encrypted in the add-on's private `/data` folder, using `database_encryption_key`. Losing that key makes existing data unreadable — back it up outside Home Assistant.
- See [upstream README](https://github.com/felixschndr/quaestor#environment-variables) for what each option does.
