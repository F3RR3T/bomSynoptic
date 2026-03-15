#!/bin/bash
set -euo pipefail

# Run once on pestrel as root (or with sudo) to install the synoptic service.
# Usage: sudo ./setup.sh

if [ "$(id -u)" -ne 0 ]; then
    echo "Must run as root or with sudo." >&2
    exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
OWNER=st33v

# ---------------------------------------------------------------------------
# Nginx conflict checks
# ---------------------------------------------------------------------------
echo "==> Checking for nginx conflicts..."

CONFLICT=0

if grep -rl "server_name.*pestrel\.com" /etc/nginx/ 2>/dev/null; then
    echo "WARNING: The above nginx config(s) already reference pestrel.com — check for duplicate server blocks."
    CONFLICT=1
fi

if grep -rl "listen.*80.*default_server" /etc/nginx/ 2>/dev/null; then
    echo "WARNING: The above nginx config(s) define a default_server on port 80 — may intercept traffic intended for this site."
    CONFLICT=1
fi

if ! grep -q "include.*conf\.d" /etc/nginx/nginx.conf 2>/dev/null; then
    echo "WARNING: /etc/nginx/nginx.conf does not appear to include conf.d/*.conf — you may need to add the following line manually:"
    echo "         include /etc/nginx/conf.d/*.conf;"
    CONFLICT=1
fi

[ "$CONFLICT" -eq 0 ] && echo "    No conflicts detected."

# ---------------------------------------------------------------------------
# Directories
# ---------------------------------------------------------------------------
echo "==> Creating directories..."
install -d -o "$OWNER" -g "$OWNER" /opt/synoptic
install -d -o "$OWNER" -g "$OWNER" /var/lib/synoptic
install -d -o "$OWNER" -g "$OWNER" /var/lib/synoptic/archive
install -d -o "$OWNER" -g "$OWNER" /var/lib/synoptic/archive/raw
install -d -o "$OWNER" -g "$OWNER" /srv/www

# ---------------------------------------------------------------------------
# Web content
# ---------------------------------------------------------------------------
echo "==> Writing index.html..."
install -o "$OWNER" -g "$OWNER" -m 644 "$SCRIPT_DIR/index.html" /srv/www/index.html

# ---------------------------------------------------------------------------
# Systemd units
# ---------------------------------------------------------------------------
echo "==> Installing systemd unit files..."
for unit in synoptic.service synoptic.timer synoptic-retry.service synoptic-retry.timer; do
    install -m 644 "$SCRIPT_DIR/systemd/${unit}" "/etc/systemd/system/${unit}"
    echo "    installed ${unit}"
done

echo "==> Reloading systemd and enabling timer..."
systemctl daemon-reload
systemctl enable --now synoptic.timer

# ---------------------------------------------------------------------------
# Nginx
# ---------------------------------------------------------------------------
echo "==> Installing nginx config..."
install -m 644 "$SCRIPT_DIR/nginx/pestrel.com.conf" /etc/nginx/conf.d/synoptic.conf

echo "==> Testing nginx config..."
nginx -t

echo "==> Reloading nginx..."
systemctl reload nginx

# ---------------------------------------------------------------------------
echo "==> Done."
echo "    Run 'systemctl list-timers synoptic.timer' to confirm next scheduled run."
