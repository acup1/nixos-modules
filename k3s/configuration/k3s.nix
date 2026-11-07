{
  services.k3s = {
    enable = true;
    role = "server";
  };

  # Kubernetes pod and overlay traffic must not be filtered by the host
  # firewall. The API itself is deliberately not opened here; consumers can
  # expose it through a trusted network or a private proxy.
  networking.firewall.trustedInterfaces = [
    "cni0"
    "flannel.1"
  ];
}
