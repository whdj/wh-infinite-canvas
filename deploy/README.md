# Tencent Cloud Lighthouse deployment

Target: Ubuntu 24.04 on the existing Lighthouse instance, with Caddy serving
`https://canvas.metal-anchor.site`. The application uses port `30010` on
`127.0.0.1`. This is a single-user service: protect the entire host with Caddy
HTTP Basic authentication before making it public. The API includes filesystem
and external-service operations and is not safe to expose anonymously.

Do not use the credentials or databases of other applications on this server.
The browser/Photoshop connectors and local ComfyUI/CLI features still require
their corresponding services on the machine they connect to; a remote server
does not gain access to software installed on a visitor's PC.

1. Confirm `canvas.metal-anchor.site` points to this server, port `30010` is
   unused, and `/etc/caddy/Caddyfile` has no site block for that host.
2. Create a dedicated system account and install the public repository. Keep
   the checkout path aligned with the service file:

   ```sh
   sudo useradd --system --home-dir /var/lib/whcanvas --create-home --shell /usr/sbin/nologin whcanvas
   sudo git clone https://github.com/whdj/wh-infinite-canvas.git /opt/wh-infinite-canvas
   sudo chown -R whcanvas:whcanvas /opt/wh-infinite-canvas
   ```

3. Install Python 3 and venv, then install dependencies as the service user:

   ```sh
   sudo apt-get update
   sudo apt-get install -y python3-venv python3-pip
   sudo -u whcanvas python3 -m venv /opt/wh-infinite-canvas/.venv
   sudo -u whcanvas /opt/wh-infinite-canvas/.venv/bin/pip install -r /opt/wh-infinite-canvas/requirements.txt
   sudo install -m 0644 /opt/wh-infinite-canvas/deploy/wh-infinite-canvas.service /etc/systemd/system/wh-infinite-canvas.service
   sudo systemctl daemon-reload
   sudo systemctl enable --now wh-infinite-canvas.service
   curl -fsS http://127.0.0.1:30010/api/app-info
   ```

4. Run `caddy hash-password` and set a new unique password. Append the site
   block from `deploy/Caddyfile.example` to the *existing* server-side
   `/etc/caddy/Caddyfile`, replacing the placeholder there with the hash.
   Never write the hash to a tracked file. Validate and reload Caddy; do not overwrite
   the existing site blocks for other services:

   ```sh
   sudo cp /etc/caddy/Caddyfile /etc/caddy/Caddyfile.bak.wh-canvas
   sudo caddy validate --config /etc/caddy/Caddyfile
   sudo systemctl reload caddy
   ```

5. Confirm the public URL returns `401` without credentials and `200` after
   authentication. Test canvas save/reload and a WebSocket connection in the
   browser. Keep API credentials under `API/.env` or in
   `/etc/wh-infinite-canvas.env` with mode `0600`. Back up `data/`, `assets/`,
   `output/`, `API/.env` and other local runtime content independently of Git.
