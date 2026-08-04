# ST-PRO DACT app image.
# Docker equivalent of the "STProDactApp" Windows service (STProDact.iss).
# The Windows installer copied the node runtime plus the application payload
# ({app}\node\node.exe, {app}\app\server.js, {app}\app\node_modules). Here the
# official node image provides the runtime and the application payload comes
# from this directory.

FROM node:22

WORKDIR /app

# Application payload (equivalent of {app}\app)
COPY package.json ./
COPY server.js ./

# Pre-bundled dependencies. The repository ships the full node_modules tree,
# so no network access is required at build time.
COPY node_modules ./node_modules

# Entry point that mirrors the Windows service user (STProDactSvc) setup:
# grants the container user write access to the data directories and drops
# privileges before starting the app.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# App port inside the container. Caddy (the proxy) forwards to this port.
ENV PORT=3000

# Expose the port to the host. Caddy will forward to this port.
EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["node", "server.js"]
