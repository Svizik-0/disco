{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mynixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Kyiv";

  users.users.sova = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    # Тимчасовий пароль — обовʼязково зміните після першого входу через passwd
    initialPassword = "changeme";
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # Додайте свій публічний ключ, щоб одразу мати SSH-доступ після встановлення
  users.users.sova.openssh.authorizedKeys.keys = [
    # "ssh-ed25519 AAAA... your-key-comment"
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  system.stateVersion = "25.05";
}
