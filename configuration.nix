# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
 

{ config, pkgs, inputs, flake-overlays ? [], ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
    };
  };
  # boot.loader.systemd-boot.enable = true; may remove later keeping for now for testing reasons
  # boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Add Kernel Parameters
  boot.kernelParams = [
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    "i915.enable_dpcd_backlight=1"
    "nvidia.NVreg_DynamicPowerManagement=0x02"
    "nvidia.NVreg_EnableS0ixPowerManagement=1"
  ];

  # Also setting special env vars for NVIDIA
  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
    __NV_PRIME_RENDER_OFFLOAD = "0";
    __VK_LAYER_NV_optimus = "non_NVIDIA_only";
    LIBVA_DRIVER_NAME = "iHD";
    DXVK_FILTER_DEVICE_NAME = "Intel";
    VKD3D_FILTER_DEVICE_NAME = "Intel";
    DRI_PRIME = "0";
    NIXOS_OZONE_WL = "1";
  };

  networking.hostName = "NixG16"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true; # enables waylamnd for SDDM
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sessionPackages = [ # exposes Hyprland to sddm for selection
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable supergfxctl
  services.supergfxd.enable = true;

  # Enable Asusctl/ROG control center
  services = {
    asusd = {
	enable = true;
	enableUserService = true;
    };
  };

  # set up and enable TuneD ppd
  services.tuned = {
    enable = true;
    ppdSupport = true;
  };

  # allow TuneD to auto-switch on AC/Battery
  services.upower.enable = true;

  # enable Zsh for selected user
  programs.zsh.enable = true;
  users.users.pupo.shell = pkgs.zsh;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pupo = {
    isNormalUser = true;
    description = "pupo";
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };
  users.extraGroups.vboxusers.members = ["pupo"];

  # Hyprland Cachix setup (prevents recomp. of Hyprland and its dependencies every update)
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Enable container configs in /etc/containers
  virtualisation = {
    containers.enable = true;
    podman = {
	enable = true;
	# create docker alias for podman
	dockerCompat = true;
	# Required for containers under podman-compose to be able to communicate
	defaultNetwork.settings.dns_enabled = true;
    };
    virtualbox = {
	host.enable = true;
	host.enableExtensionPack = true;
	guest.enable = true;
	guest.dragAndDrop = true;
    };
  };

  # Enable OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Install Gamemode
  programs.gamemode.enable = true;

  # Enable Tailscale
  services.tailscale.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Helps proprietary apps/wheels find right glibc/driver paths (for cuda)
  programs.nix-ld.enable = true;

  # Add overlays from flakes
  nixpkgs.overlays = flake-overlays;
  
  # enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   git
   lshw
   wget
   wine # needed for windows applications (covers both 32 and 64-bit applications)
   winetricks
   cudaPackages.cudatoolkit # cuda runtime libs for cuda in apps (minimal install)
   obsidian
   kitty
   distrobox
   nasm
   gcc
   podman
   glxinfo
   libva-utils
   lsof
   htop
   cmake
   gnumake
  ];
  
  # Setup Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  # Enable UWSM session
  programs.uwsm.enable = true;

  # Setup Screensharing
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
	xdg-desktop-portal-gtk
	xdg-desktop-portal-hyprland
    ];
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
      vpl-gpu-rt
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-vaapi-driver
    ];
  };

  # Load nvidia driver for Xorg/Wayland
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  # Nvidia driver settings
  hardware.nvidia = {
    
    # modesetting - hard requirement
    modesetting.enable = true;

    # Nvidia power mgnt, equiv of Arch kernel param of saving vram to /tmp/var/ for sleep/suspend
    # may break sleep/suspend tho need to test
    powerManagement.enable = true;

    # sets up more fine grained power mgnt, turns off GPU when not in use (equiv to D3cold)
    powerManagement.finegrained = true;

    # enables nvidia open driver
    open = true;

    # enables Nvidia-settings
    nvidiaSettings = true;

    # set package version
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    # above is old, pulling from nixpkgs-stable, below pulls from unstable with vers matching to stable linux kernel vers to prevent failed builds
    package = (inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.linuxPackagesFor config.boot.kernelPackages.kernel).nvidiaPackages.beta;
  };
  
  hardware.nvidia.prime = {
    # Enable Nvidia-Offload
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    # adding correct bus IDs for PRIME offload
    intelBusId = "PCI:0:2:0"; # needed for Nvidia PRIME offloading
    nvidiaBusId = "PCI:1:0:0";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
