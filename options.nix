# Options of configuration

{ pkgs, ... }: {
  lib = {
    users = {
      ash = {
        enable = true;
        packages = with pkgs; [
          deluge
          hunspell
          hunspellDicts.en-us-large
          zoom-us
          thunderbird
          spotify
          firefox
          tdesktop
          emacs
          minecraft
          virtmanager
          texlive.combined.scheme-full
        ];
      };
    };

    devices = { x1c7 = { enable = true; }; };

    system = { hostname = "nixos"; };
  };
}
