{ config, lib, pkgs, nixgl, ... }:

let

  nixGL.packages = import <nixgl> { inherit pkgs; };
  pkgsUnstable = import <nixpkgs-unstable> {};

in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "joshua";
  home.homeDirectory = "/home/joshua";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.ansible
    pkgs.ansible-lint
    pkgs.ast-grep
    pkgs.autorandr
    pkgs.awscli2
    pkgs.bat
    pkgs.bitwarden-cli
    pkgs.calc
    pkgs.chromium
    pkgs.dmenu
    pkgs.dunst # desktop notification
    pkgs.fd
    pkgs.ffcast
    pkgs.fzf
    pkgs.groovy
    pkgs.haskellPackages.kmonad
    pkgs.htop
    pkgs.hyperfine
    pkgs.jira-cli-go
    pkgs.jq
    pkgs.just
    pkgs.kdePackages.breeze
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.dolphin-plugins
    pkgs.kdePackages.kde-gtk-config
    pkgs.kitty
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kubetail
    pkgs.lazygit
    pkgs.luarocks-nix
    pkgs.lxappearance
    pkgs.maim
    pkgs.nitrogen
    pkgs.vagrant
    pkgs.nodejs_22
    pkgs.parallel
    pkgs.picom
    # pkgs.qutebrowser
    (config.lib.nixGL.wrap pkgs.qutebrowser)
    pkgs.redis
    pkgs.ripgrep
    pkgs.rofi
    pkgs.rofimoji
    pkgs.screenkey # show keyboard input on screen
    pkgs.shellcheck
    pkgs.skopeo # interact with remote oci registries
    pkgs.slop # For use with screen_record
    pkgs.spotify
    pkgs.sshpass
    pkgs.starship
    pkgs.tldr
    # pkgs.unclutter
    pkgs.up
    pkgs.virt-manager
    pkgs.volctl
    pkgs.xdotool
    pkgs.xfce.thunar
    pkgs.yadm
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/joshua/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
