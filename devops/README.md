# Модуль `devops`

* **Экспорт**: `nixos`, `darwin`
* **Назначение**: Контейнеризация, виртуализация и инфраструктурный инструментарий (DevOps).

## Структура

* `default.nix` — экспортирует конфигурацию NixOS и nix-darwin.
* `nixos.nix` — подключает `configuration/` и `packages/`.
* `configuration/libvirtd.nix`:
  * Настройка демона виртуализации `virtualisation.libvirtd` с пакетом `pkgs.qemu_kvm`, правами root и эмулятором TPM `swtpm`.
* `packages/devops.nix`:
  * Контейнеры и оркестрация: `docker`, `docker-compose`, `kubectl`.
  * Kubernetes: `kubectl`, `helm`, `minikube`.
  * Docker в macOS: `colima` с автозапуском через LaunchAgent.
  * Виртуализация в NixOS: `qemu`, `virt-manager`.
  * Инфраструктура как код (IaC): `terraform`, `terragrunt`.

На macOS в `components.devops.enabledPackages` можно дополнительно включить `libvirt`, `qemu`, `swtpm` и `virt-manager`. Эти переключатели устанавливают пакеты. Служба `virtualisation.libvirtd` относится к конфигурации NixOS.
