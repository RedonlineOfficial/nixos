{ self, inputs, ... }: {
  flake.nixosModules."site1-ws-nix-01" = { pkgs, ... }: {
    # Boot
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Hibernation
    boot.initrd.systemd.enable = true;
    boot.resumeDevice = "/dev/mapper/cryptroot";
    boot.kernelParams = ["mem_sleep_default=deep"];

    swapDevices = [{
      device = "/var/lib/swapfile";
      size = 34 * 1024;
    }];

    services.logind.settings.Login = {
      LidSwitch = "suspend-then-hibernate";
      LidSwitchDocked = "ignore";
      PowerKey = "hibernate";
      PowerKeyLongPress = "poweroff";
    };
    
    # Nix
    nixpkgs.config.allowUnfree = true;
    nix = {
      settings.experimental-features = [ "flakes" "nix-command" ];
      gc = {
        automatic = true;
        dates = "Sun 00:00:00";
        persistent = true;
      };

      optimise = {
        automatic = true;
        dates = "Sun 01:00:00";
        persistent = true;
      };
    };
    
    # Networking
    networking = {
      hostName = "site1-ws-nix-01";
      domain = "redonline.lan";
      networkmanager.enable = true;
    };

    # Power Management
    services = {
      tlp.enable = false;
      power-profiles-daemon.enable = false;
      auto-cpufreq.enable = true;
    };

    # Firmware
    hardware.enableAllFirmware = true;
    services.fwupd.enable = true;

    # Locale
    time.timeZone = "America/Phoenix";
    i18n.defaultLocale = "en_US.UTF-8";

    # Packages
    environment.systemPackages = with pkgs; [
      neovim
      wget
      curl
      zsh
      nvme-cli
      smartmontools
      pciutils
      usbutils
      dnsutils
      nmap
      ripgrep
      fd
      fzf
      btop
      tre-command
      gh
      bitwarden-cli
    ];

    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        core.editor = "nvim -f";
        user.name = "Redonline";
        user.email = "dev@redonline.me";
      };
    };
    programs.zsh.enable = true;

    # State Version - DO NOT CHANGE THIS EVER!!!!!!!!1!1
    system.stateVersion = "26.05";
  };
}

