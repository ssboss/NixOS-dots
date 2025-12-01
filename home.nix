{config, pkgs, inputs, ...}:

{
    imports = [
    ./hyprland/hyprland.nix
    ];

 	# description = "Home-Manager Configuration";
	home.username = "pupo";
	home.homeDirectory = "/home/pupo"; 
	home.packages = with pkgs; [
		home-manager # fuck u im not running nixos-rebuild to change settings >:(
		neofetch
		nnn # terminal file manager
		nautilus # gui file manager for hyprland
		

		# archive
		zip
		unzip
		p7zip
		rar

		# misc
		which
		tree

		btop # htop replacement

		# system tools
		pciutils
		usbutils
		
		# code editors
		zed-editor
		
		# e-book
		calibre
		
		# Hyprland extras
		wofi
		waybar
		swaynotificationcenter
		networkmanagerapplet
		wireplumber
		brightnessctl
		hyprlock
		hypridle
		hyprpaper
		wl-clipboard
		clipman
		hyprshot
		playerctl

		# messaging
		discord

		# browser/s
		brave
	];

	programs.librewolf = {
	  enable = true;
	  settings = {
	    "privacy.clearnOnShutdown.history" = false;
	  };
	};

	programs.git = {
	  enable = true;
	  userName = "ssboss";
	  userEmail = "12957633+ssboss@users.noreply.github.com";
	};

	programs.alacritty = {
	  enable = true;
	  settings = {
		font.draw_bold_text_with_bright_colors = true;
		selection.save_to_clipboard = true;
		};
	};
	
	programs.waybar = {
	  enable = true;
	};

	programs.wofi = {
	  enable = true;
	};

	programs.vscode = {
	  enable = true;
	  extensions = with pkgs.vscode-extensions; [
	    ms-python.python
	    ms-azuretools.vscode-docker
	    ms-vscode.cpptools-extension-pack
	    ms-vscode.cpptools
	    ms-toolsai.jupyter
	    ms-vscode-remote.remote-ssh
	    ms-vscode-remote.vscode-remote-extensionpack
	    ms-vscode-remote.remote-ssh-edit
	    ecmel.vscode-html-css
	    bradgashler.htmltagwrap
	  ];
	};

	programs.kitty.enable = true;
	
    # Zsh install, config, and enable
    programs.zsh = {
      enable = true;
      initContent = ''export PATH="$HOME/.local/bin:$PATH"'';
      history.size = 10000;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "ssh" "ssh-agent" "tailscale" "zsh-navigation-tools" "vscode" "docker-compose" "conda" "aliases" "alias-finder"];
      };
    };


	# Hyprland Environmental Vars for nvidia
	# home.sessionVariables = {
		# VK_LOADER_DRIVERS_SELECT = "*intel_icd*";
  		# DXVK_FILTER_DEVICE_NAME = "Intel";
  		# VKD3D_FILTER_DEVICE_NAME = "Intel";
  		# MESA_VK_DEVICE_SELECT = "8086:*";
  		# __GLX_VENDOR_LIBRARY_NAME = "mesa";
  		# __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/egl/egl_vendor.d/50_mesa.json";
  		# __NV_PRIME_RENDER_OFFLOAD = "0";
  		# __VK_LAYER_NV_optimus = "non_NVIDIA_only";
  		# DRI_PRIME = "0";
  		# LIBVA_DRIVER_NAME = "iHD";
  		# VDPAU_DRIVER = "va_gl";
  		# WLR_RENDER_DRM_DEVICE = "/dev/dri/renderD128";
	# };

	
	# expose HM env vars to UWSM
	#  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";	
	
	# expose envs via literal file
	# home.file.".config/uwsm/env".text = ''
	# __GLX_VENDOR_LIBRARY_NAME = "mesa";
	# LIBVA_DRIVER_NAME = "iHD";
	# DRI_PRIME = "0";
	# NIXOS_OZONE_WL = "1";
	# ELECTRON_OZONE_PLATFORM_HINT = "auto";
	#
	# '?|}{:> }"';
	# old stuff used by Hyprland, testing above for hybrid setup

	# ''
	# ELECTRON_OZONE_PLATFORM_HINT="auto"
	# LIBVA_DRIVER_NAME="nvidia"
	# LOCALE_ARCHIVE_2_27="/nix/store/yh4pcxljbcbn126v6mg3139hii40i7ny-glibc-locales-2.40-66/lib/locale/locale-archive"
	# NIXOS_OZONE_WL="1"
	# NVD_BACKEND="direct"
	# __GLX_VENDOR_LIBRARY_NAME="nvidia"
	# '';

	# value determines home manager release that config has compatability w/, avoids breakage w/ new home manager versions and their new backwards incompatible changes
	# note: home manager can be updated w/o changing value
	home.stateVersion = "25.05";
}
	
