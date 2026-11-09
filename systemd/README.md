# Systemd - User vs System Service

```sh
# System services: rootful, requires sudo, system-wide
# Location: /etc/containers/systemd/
# Manage: sudo systemctl
# Target: multi-user.target

# User services: rootless, no sudo, per-user isolation
# Location: ~/.config/containers/systemd/
# Manage: systemctl --user
# Target: default.target
```
