# K3s server

Enables a schedulable single-node K3s server with its default SQLite
datastore. The module trusts only the internal CNI and Flannel interfaces and
does not expose the Kubernetes API through the host firewall.

Host-specific settings such as TLS SANs, public addresses, and proxies belong
in the host configuration or a private module.
