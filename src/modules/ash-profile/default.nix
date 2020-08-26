{ pkgs, lib, config, ... }:

with lib;

let
  inherit (config.std) system;
  gnomeEnable = config.services.xserver.desktopManager.gnome3.enable;
  cfg = config.ash-profile;
  mkUserConfigs = f: (attrsets.mapAttrs (n: c: (f n c)) cfg);
in {
  options.ash-profile = mkOption {
    type = with types;
      attrsOf (submodule {
        options = {
          extraPackages = mkOption {
            type = with types; listOf package;
            description =
              "Extra packages to install for user <literal>ash</literal>.";
          };
        };
      });
    default = { };
  };

  config.home-manager.users = mkUserConfigs (n: c: {
    # Home-manager settings.
    # User-layer packages
    home.packages = with pkgs;
      [ hunspell hunspellDicts.en-us-large emacs ] ++ c.extraPackages;

    # Allow fonts to be discovered
    fonts.fontconfig.enable = true;

    # Package settings
    programs = {
      # GnuPG
      gpg = {
        enable = true;
        settings = { throw-keyids = false; };
      };

      # Git
      git = {
        enable = true;
        userName = "Harry Ying";
        userEmail = "lexugeyky@outlook.com";
        signing = {
          signByDefault = true;
          key = "0xAE53B4C2E58EDD45";
        };
        extraConfig = { credential = { helper = "store"; }; };
      };

      gnome-terminal = mkIf (gnomeEnable) {
        enable = true;
        profile.aba3fa9f-5aab-4ce9-9775-e2c46737d9b8 = {
          default = true;
          visibleName = "Ash";
          font = "Fira Code weight=450 10";
        };
      };

      # zsh
      zsh = {
        enable = true;
        # This would make C-p, C-n act exactly the same as what up/down arrows do.
        initExtra = ''
          bindkey "^P" up-line-or-search
          bindkey "^N" down-line-or-search
        '';
        envExtra = "";
        defaultKeymap = "emacs";
        oh-my-zsh = {
          enable = true;
          theme = "agnoster";
          plugins = [ "git" ];
        };
      };
    };

    # Setting GNOME Dconf settings
    dconf.settings = mkIf (gnomeEnable) {
      # Touchpad settings
      "org/gnome/desktop/peripherals/touchpad" = {
        disable-while-typing = false;
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
      };
      # Favorite apps
      "org/gnome/shell" = {
        favorite-apps = [
          "firefox.desktop"
          "telegramdesktop.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.Terminal.desktop"
          "emacs.desktop"
        ];
      };
    };

    # Handwritten configs
    home.file = {
      ".config/gtk-3.0/settings.ini".source =
        (system.dirs.dotfiles."${n}" + /gtk-settings.ini);
      ".emacs.d/init.el".source =
        (system.dirs.dotfiles."${n}" + /emacs.d/init.el);
      ".emacs.d/elisp/".source = (system.dirs.dotfiles."${n}" + /emacs.d/elisp);
    };
  });
}
