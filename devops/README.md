# Модуль `devops`

* Доступны части `nixos` и `darwin`.
* **Назначение**: Контейнеризация, виртуализация и инфраструктурный инструментарий (DevOps).

## Структура

* `default.nix` — экспортирует конфигурацию NixOS и nix-darwin.
* `nixos.nix` — подключает `configuration/` и `packages/`.
* `darwin.nix` — подключает `packages/` и запускает Colima с Docker как пользовательский LaunchAgent.
* `configuration/libvirtd.nix`:
  * Настройка демона виртуализации `virtualisation.libvirtd` с пакетом `pkgs.qemu_kvm`, правами root и эмулятором TPM `swtpm`.
* `packages/devops.nix`:
  * Контейнеры и оркестрация: `docker`, `docker-compose`, `kubectl`.
  * В NixOS устанавливаются `qemu`, `virt-manager` и `winboat`.
  * В macOS устанавливаются `colima`, `kubernetes-helm` и `minikube`.
  * Инфраструктура как код (IaC): `terraform`, `terragrunt`.

На macOS в `components.devops.enabledPackages` можно дополнительно включить `libvirt`, `qemu`, `swtpm` и `virt-manager`. Эти переключатели устанавливают пакеты. Служба `virtualisation.libvirtd` относится к конфигурации NixOS.
